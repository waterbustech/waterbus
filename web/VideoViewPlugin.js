'use strict';
/*!
 * @license
 * https://github.com/xxoo/flutter_video_view/blob/main/web/VideoViewPlugin.js
 * Copyright 2025 Xiao Shen.
 * Licensed under BSD 2-Clause.
 */
globalThis.VideoViewPlugin = class VideoViewPlugin {
	static version = '1.2.2';
	/** @type {Map<number, VideoViewPlugin>} */
	static #instances = new Map();
	static #nextId = 0;
	static #isApple = navigator.vendor.startsWith('Apple');

	static #hasMSE = typeof ManagedMediaSource === 'function' || typeof MediaSource === 'function' && typeof MediaSource.isTypeSupported === 'function';

	static #unmuteOption = {
		capture: true,
		passive: true
	};

	/** @param {number} id */
	static getInstance(id) {
		return this.#instances.get(id);
	}

	/** @param {TextTrack} track */
	static #isSubtitle = track => ['subtitles', 'captions', 'forced'].includes(track.kind);

	/**
	 * @param {TextTrackList|AudioTrackList} trackList
	 * @param {number} i
	 */
	static #getTrackId = (trackList, i) => trackList[i].id ? +trackList[i].id : i;

	/**
	 * @param {Map<number, string[]>} langs
	 * @returns {number}
	 */
	static #getBestMatch = langs => {
		if (langs.size === 0) {
			return -1;
		} else if (langs.size === 1) {
			return langs.keys().next().value;
		} else {
			let count = 3,
				j = 0;
			for (const [i, t] of langs) {
				if (t.length < count) {
					j = i;
					count = t.length;
				}
			}
			return j;
		}
	};

	/**
	 * @param {string[]} langArr
	 * @param {Map<number, string[]>} langs 
	 */
	static #getBestMatchByLanguage = (langArr, langs) => {
		if (langs.size === 0) {
			return -1;
		} else {
			const lang1 = new Map(),
				lang2 = new Map();
			for (const [i, t] of langs) {
				if (langArr[0] === t[0]) {
					lang1.set(i, t);
					if (langArr.length > 1 && t.length > 1 && langArr[1] === t[1]) {
						lang2.set(i, t);
						if (langArr.length > 2 && t.length > 2 && langArr[2] === t[2]) {
							return i;
						}
					}
				}
			}
			let j = this.#getBestMatch(lang2);
			if (j < 0) {
				j = this.#getBestMatch(lang1);
			}
			return j;
		}
	};

	#looping = false;
	#autoPlay = false;
	#volume = 1;
	#speed = 1;
	#playTime = 0;
	#preferredAudioLanguage = '';
	#preferredSubtitleLanguage = '';
	#maxBitrate = Infinity;
	#maxVideoWidth = Infinity;
	#maxVideoHeight = Infinity;
	#overrideAudioTrack = -1;
	#overrideSubtitleTrack = -1;
	#showSubtitle = false;
	#live = false;
	#source = '';
	#position = 0;
	#bufferPosition = 0;
	#subtitleOnChange = 0;
	#audioOnChange = 0;
	#fitWidth = false;

	/** 
	 * 0: idle, 1: opening, 2: ready, 3: playing
	 * @type {0|1|2|3}
	 */
	#state = 0;

	/** @type {function(Object):void} */
	#sendMessage;

	/** @type {number} */
	#id;

	/** @type {HTMLVideoElement?} */
	#dom = null;

	/** @type {shaka.Player?} */
	#shaka = null;

	/** @type {ResizeObserver?} */
	#observer = null;

	#onresize = () => this.#dom.style.objectFit = this.#dom.videoWidth / this.#dom.videoHeight > this.#dom.width / this.#dom.height
		? this.#fitWidth ? 'contain' : 'cover'
		: this.#fitWidth ? 'cover' : 'contain';

	#unmute = () => {
		if (this.#dom.muted) {
			this.#dom.muted = false;
			removeEventListener('keydown', this.#unmute, VideoViewPlugin.#unmuteOption);
			removeEventListener('keyup', this.#unmute, VideoViewPlugin.#unmuteOption);
			removeEventListener('mousedown', this.#unmute, VideoViewPlugin.#unmuteOption);
			removeEventListener('mouseup', this.#unmute, VideoViewPlugin.#unmuteOption);
			removeEventListener('touchstart', this.#unmute, VideoViewPlugin.#unmuteOption);
			removeEventListener('touchend', this.#unmute, VideoViewPlugin.#unmuteOption);
			removeEventListener('touchmove', this.#unmute, VideoViewPlugin.#unmuteOption);
		}
	};

	/** @param {Event} e */
	#displayModeChange = e => {
		if (e.target === this.#dom) {
			this.#sendDisplayMode(document.fullscreenElement === this.#dom ? 1
				: document.pictureInPictureElement === this.#dom ? 2
					: 0);
		}
	};

	/** @param {0|1|2} mode */
	#sendDisplayMode = mode => {
		if (mode === 1) {
			this.#dom.style.pointerEvents = 'auto';
			this.#dom.controls = true;
		} else {
			this.#dom.style.pointerEvents = 'none';
			this.#dom.controls = false;
		}
		this.#sendMessage({
			event: 'displayMode',
			value: mode
		});
	};

	/** @param {string} lang */
	#getDefaultAudioTrack = lang => {
		const tracks = this.#shaka ? this.#shaka.getAudioTracks() : this.#dom.audioTracks;
		if (tracks && tracks.length) {
			const langs = new Map(this.#shaka
				? tracks.map((v, i) => [i, v.language ? v.language.split('-') : []])
				: Array.prototype.map.call(tracks, (v, i) => [v.id ? +v.id : i, v.language.split('-')]));
			let j = lang ? VideoViewPlugin.#getBestMatchByLanguage(lang.split('-'), langs) : -1;
			if (j < 0) {
				if (this.#shaka) {
					j = 0;
					for (let i = 0; i < tracks.length; i++) {
						if (tracks[i].primary) {
							j = i;
						}
					}
				} else {
					for (let i = 0; i < tracks.length; i++) {
						if (j < 0 || tracks[i].kind === 'main') {
							j = VideoViewPlugin.#getTrackId(tracks, i);
						}
					}
				}
			}
			return j;
		}
		return -1;
	};

	/** @param {string} lang */
	#getDefaultSubtitleTrack = lang => {
		const langs = new Map(Array.prototype.map.call(
			this.#dom.textTracks,
			(v, i) => VideoViewPlugin.#isSubtitle(v) ? [v.id ? +v.id : i, v.language.split('-')] : null
		).filter(v => v));
		if (langs.size) {
			let j = lang ? VideoViewPlugin.#getBestMatchByLanguage(lang.split('-'), langs) : -1;
			if (j < 0) {
				j = langs.keys().next().value;
			}
			return j;
		}
		return -1;
	};

	#sendSize = () => this.#sendMessage({
		event: 'videoSize',
		width: this.#dom.videoWidth,
		height: this.#dom.videoHeight
	});

	#sendPosition = () => this.#sendMessage({
		event: 'position',
		value: this.#dom.currentTime * 1000 | 0
	});

	#sendBuffer = () => this.#sendMessage({
		event: 'buffer',
		start: this.#dom.currentTime * 1000 | 0,
		end: this.#bufferPosition * 1000 | 0
	});

	/** @param {string} msg */
	#sendError = msg => {
		this.#close();
		this.#sendMessage({
			event: 'error',
			value: msg
		});
	};

	#setAudioTrack = () => {
		const trackId = this.#overrideAudioTrack < 0 ? this.#getDefaultTrack(1) : this.#overrideAudioTrack;
		if (this.#shaka) {
			const audioTracks = this.#shaka.getAudioTracks();
			if (trackId >= 0 && trackId < audioTracks.length) {
				this.#shaka.selectAudioTrack(audioTracks[trackId]);
			}
		} else if (this.#dom.audioTracks) {
			const audioTracks = this.#dom.audioTracks;
			for (let i = 0; i < audioTracks.length; i++) {
				const enabled = VideoViewPlugin.#getTrackId(audioTracks, i) === trackId;
				if (audioTracks[i].enabled !== enabled) {
					audioTracks[i].enabled = enabled;
				}
			}
		}
	};

	#setSubtitleTrack = () => {
		const trackId = !this.#showSubtitle ? -1
			: this.#overrideSubtitleTrack < 0 ? this.#getDefaultTrack(2)
				: this.#overrideSubtitleTrack;
		const textTracks = this.#dom.textTracks;
		for (let i = 0; i < textTracks.length; i++) {
			const mode = VideoViewPlugin.#getTrackId(textTracks, i) === trackId ? 'showing' : 'disabled';
			if (textTracks[i].mode !== mode) {
				textTracks[i].mode = mode;
			}
		}
	};

	#configureShaka = () => this.#shaka.configure({
		abr: {
			restrictions: {
				maxHeight: this.#maxVideoHeight,
				maxWidth: this.#maxVideoWidth,
				maxBandwidth: this.#maxBitrate
			}
		}
	});

	/**
	 * 1: audio, 2: subtitle
	 * @param {1|2} type
	 */
	#getDefaultTrack = type => {
		const [lang, getDefaultTrack] = type === 1
			? [this.#preferredAudioLanguage, this.#getDefaultAudioTrack]
			: [this.#preferredSubtitleLanguage, this.#getDefaultSubtitleTrack];
		if (lang) {
			const j = getDefaultTrack(lang);
			if (j >= 0) {
				return j;
			}
		}
		for (let i = 0; i < navigator.languages.length; i++) {
			const j = getDefaultTrack(navigator.languages[i].toLowerCase());
			if (j >= 0) {
				return j;
			}
		}
		return getDefaultTrack();
	};

	#close = () => {
		this.pause();
		this.#unmute();
		this.#state = 0;
		this.#source = '';
		this.#live = false;
		this.#playTime = 0;
		this.#position = 0;
		if (this.#shaka) {
			this.#shaka.destroy();
			this.#shaka = null;
		} else {
			for (const src of this.#dom.getElementsByTagName('source')) {
				src.remove();
			}
			this.#dom.removeAttribute('src');
			this.#dom.load();
		}
		if (!VideoViewPlugin.#isApple) {
			if (document.fullscreenEnabled) {
				removeEventListener('fullscreenchange', this.#displayModeChange);
			}
			if (document.pictureInPictureEnabled) {
				removeEventListener('enterpictureinpicture', this.#displayModeChange);
				removeEventListener('leavepictureinpicture', this.#displayModeChange);
				if (document.pictureInPictureElement === this.#dom) {
					document.exitPictureInPicture();
				}
			}
		}
		this.setStyle('');
		this.#dom = null;
	};

	#play = () => {
		const state = this.#state;
		this.#dom.play().catch(e => {
			if (this.#state === state) {
				// browser may require user interaction to play media with sound
				// in this case, we can mute the media first and then unmute it when user interacts with the page
				if (e.name === 'NotAllowedError') {
					if (!this.#dom.muted) {
						this.#dom.muted = true;
						addEventListener('keydown', this.#unmute, VideoViewPlugin.#unmuteOption);
						addEventListener('keyup', this.#unmute, VideoViewPlugin.#unmuteOption);
						addEventListener('mousedown', this.#unmute, VideoViewPlugin.#unmuteOption);
						addEventListener('mouseup', this.#unmute, VideoViewPlugin.#unmuteOption);
						addEventListener('touchstart', this.#unmute, VideoViewPlugin.#unmuteOption);
						addEventListener('touchend', this.#unmute, VideoViewPlugin.#unmuteOption);
						addEventListener('touchmove', this.#unmute, VideoViewPlugin.#unmuteOption);
					}
					this.#play();
				}
			}
		});
	};

	/**
	 * sendMessage: callback function from dart side
	 * @param {function(Object):void} sendMessage 
	 */
	constructor(sendMessage) {
		this.#id = VideoViewPlugin.#nextId++;
		VideoViewPlugin.#instances.set(this.#id, this);
		this.#sendMessage = sendMessage;
	}

	get id() {
		return this.#id;
	}

	/** @returns {HTMLVideoElement} */
	get dom() {
		return this.#dom;
	}

	dispose() {
		VideoViewPlugin.#instances.delete(this.#id);
		this.close();
	}

	/** @param {string} url */
	open(url) {
		this.close();
		this.#dom = document.createElement('video');
		this.#dom.style.display = 'block';
		this.#dom.style.width = '100%';
		this.#dom.style.height = '100%';
		this.#dom.style.pointerEvents = 'none';
		this.#dom.style.objectFit = 'fill';
		this.#dom.playbackRate = this.#speed;
		this.#dom.volume = this.#volume;
		this.#dom.preload = 'auto';
		this.#dom.playsInline = true;
		this.#dom.disableRemotePlayback = true;
		this.#dom.controls = false;
		this.#dom.autoplay = false;
		this.#dom.loop = false;
		if (this.#dom.controlsList) {
			this.#dom.controlsList.add('nodownload');
		}
		if ('webkitTouchCallout' in this.#dom.style) {
			this.#dom.style.webkitTouchCallout = 'none';
		} else {
			this.#dom.addEventListener('contextmenu', e => e.preventDefault());
		}
		this.#dom.addEventListener('ratechange', () => {
			if (this.#dom.playbackRate > 2) {
				this.#dom.playbackRate = 2;
			} else if (this.#dom.playbackRate < 0.5) {
				this.#dom.playbackRate = 0.5;
			} else {
				this.#sendMessage({
					event: 'speed',
					value: this.#dom.playbackRate
				});
			}
		});
		this.#dom.addEventListener('volumechange', () => this.#sendMessage({
			event: 'volume',
			value: this.#dom.volume
		}));
		this.#dom.addEventListener('waiting', () => {
			if (this.#state > 1) {
				this.#sendMessage({
					event: 'loading',
					value: true
				});
			}
		});
		this.#dom.addEventListener('playing', () => {
			if (this.#state > 1) {
				this.#sendMessage({
					event: 'loading',
					value: false
				});
			}
		});
		this.#dom.addEventListener('seeking', () => {
			if (this.#state > 1) {
				this.#sendMessage({
					event: 'seeking',
					value: true
				});
				this.#sendPosition();
			}
		});
		this.#dom.addEventListener('seeked', () => {
			if (this.#state > 1) {
				this.#sendMessage({
					event: 'seeking',
					value: false
				});
			}
		});
		this.#dom.addEventListener('timeupdate', () => {
			if (this.#state > 1) {
				this.#sendPosition();
			}
		});
		this.#dom.addEventListener('play', e => {
			if (this.#playTime) {
				this.#playTime = e.timeStamp;
			}
			if (this.#state === 2) {
				this.#state = 3;
				this.#sendMessage({
					event: 'playing',
					value: true
				});
			}
		});
		this.#dom.addEventListener('pause', e => {
			if (this.#state === 3) {
				if (this.#dom.duration === this.#dom.currentTime) { // ended
					this.#sendMessage({ event: 'finished' });
					if (this.#live) {
						this.#close();
					} else if (this.#looping) {
						this.#playTime = 0;
						this.#play();
					} else {
						this.#state = 2;
						this.#playTime = 0;
					}
				} else if (e.timeStamp - this.#playTime < 50) { // auto play may stop immediately on chrome
					this.#play();
				} else { // paused
					this.#state = 2;
					this.#playTime = 0;
					this.#sendMessage({
						event: 'playing',
						value: false
					});
				}
			}
		});
		this.#dom.addEventListener('resize', () => {
			if (this.#state > 1) {
				this.#sendSize();
			}
		});
		this.#dom.addEventListener('progress', () => {
			if (this.#state > 0 && !this.#live) {
				for (let i = 0; i < this.#dom.buffered.length; i++) {
					const end = this.#dom.buffered.end(i);
					if (this.#dom.buffered.start(i) <= this.#dom.currentTime && end >= this.#dom.currentTime) {
						if (this.#bufferPosition !== end) {
							this.#bufferPosition = end;
							if (this.#state > 1) {
								this.#sendBuffer();
							}
						}
						break;
					}
				}
			}
		});
		this.#dom.addEventListener('loadeddata', () => {
			if (this.#state === 1) {
				this.#live = this.#shaka ? this.#shaka.isLive() : this.#dom.duration === Infinity;
				this.setOverrideAudio(null);
				this.setOverrideSubtitle(null);
				if (this.#live) {
					this.#dom.playbackRate = 1;
				}
				if (this.#position > 0 && !this.#live) {
					const t = Math.min(this.#position / 1000, this.#dom.duration);
					if (this.#dom.fastSeek) {
						this.#dom.fastSeek(t);
					} else {
						this.#dom.currentTime = t;
					}
				}
			}
		});
		this.#dom.addEventListener('canplay', () => {
			if (this.#state === 1) {
				this.#state = 2;
				const audioTracks = {};
				if (this.#shaka) {
					const tracks = this.#shaka.getAudioTracks();
					for (let i = 0; i < tracks.length; i++) {
						audioTracks[i] = {
							title: tracks[i].label,
							language: tracks[i].language,
							format: tracks[i].codecs,
							sampleRate: tracks[i].audioSamplingRate | 0,
							channels: tracks[i].channelsCount | 0
						};
					}
				} else if (this.#dom.audioTracks) {
					const tracks = this.#dom.audioTracks;
					for (let i = 0; i < tracks.length; i++) {
						audioTracks[VideoViewPlugin.#getTrackId(tracks, i)] = {
							title: tracks[i].label,
							language: tracks[i].language,
							format: tracks[i].configuration?.codec,
							bitRate: tracks[i].configuration?.bitrate,
							channels: tracks[i].configuration?.numberOfChannels,
							sampleRate: tracks[i].configuration?.sampleRate
						};
					}
				}
				const subtitleTracks = {},
					tracks = this.#dom.textTracks;
				for (let i = 0; i < tracks.length; i++) {
					if (VideoViewPlugin.#isSubtitle(tracks[i])) {
						subtitleTracks[VideoViewPlugin.#getTrackId(tracks, i)] = {
							title: tracks[i].label,
							language: tracks[i].language,
							format: tracks[i].kind
						};
					}
				}
				if (this.#autoPlay) {
					this.#play();
					this.#playTime = Infinity;
				}
				this.#sendMessage({
					event: 'mediaInfo',
					duration: this.#live ? 0 : this.#dom.duration * 1000 | 0,
					audioTracks: audioTracks,
					subtitleTracks: subtitleTracks,
					source: this.#source
				});
				if (this.#position > 0) {
					this.#sendPosition();
				}
				if (this.#live && this.#bufferPosition > this.#dom.currentTime) {
					this.#sendBuffer();
				}
				if (this.#dom.videoWidth > 0 && this.#dom.videoHeight > 0) {
					this.#sendSize();
				}
			}
		});
		this.#dom.addEventListener('error', () => {
			if (this.#state > 0) {
				for (const n in MediaError) {
					if (MediaError[n] === this.#dom.error.code) {
						return this.#sendError(n);
					}
				}
				this.#sendError(this.#dom.error.message);
			}
		});
		if (VideoViewPlugin.#isApple) {
			this.#dom.addEventListener('webkitpresentationmodechanged', e => {
				if (this.#state > 0) {
					this.#sendDisplayMode({
						inline: 0,
						fullscreen: 1,
						'picture-in-picture': 2
					}[this.#dom.webkitPresentationMode]);
				}
			});
		} else {
			if (document.fullscreenEnabled) {
				addEventListener('fullscreenchange', this.#displayModeChange);
			}
			if (document.pictureInPictureEnabled) {
				addEventListener('enterpictureinpicture', this.#displayModeChange);
				addEventListener('leavepictureinpicture', this.#displayModeChange);
			}
		}
		this.#dom.textTracks.addEventListener('change', () => {
			if (this.#state > 1 && !this.#subtitleOnChange) {
				this.#subtitleOnChange = setTimeout(source => {
					this.#subtitleOnChange = 0;
					if (this.#state > 1 && this.#source === source) {
						let id = -1,
							candidate = -1;
						const textTracks = this.#dom.textTracks,
							defaultTrack = this.#overrideSubtitleTrack < 0 ? this.#getDefaultTrack(2) : this.#overrideSubtitleTrack;
						for (let i = 0; i < textTracks.length; i++) {
							if (textTracks[i].mode === 'showing' && VideoViewPlugin.#isSubtitle(textTracks[i])) {
								const trackId = VideoViewPlugin.#getTrackId(textTracks, i);
								if (trackId === defaultTrack) {
									id = trackId;
									break;
								} else if (candidate < 0) {
									candidate = trackId;
								}
							}
						}
						if (id < 0 && candidate >= 0) {
							id = candidate;
						}
						if (this.#showSubtitle) {
							if (id < 0) {
								this.#showSubtitle = false;
								this.#sendMessage({
									event: 'showSubtitle',
									value: false
								});
							} else if (id !== this.#overrideSubtitleTrack && (this.#overrideSubtitleTrack >= 0 || id !== this.#getDefaultTrack(2))) {
								this.#overrideSubtitleTrack = id;
								this.#sendMessage({
									event: 'overrideSubtitle',
									value: `${id}`
								});
							}
						} else if (id >= 0) {
							this.#showSubtitle = true;
							this.#sendMessage({
								event: 'showSubtitle',
								value: true
							});
							if (id !== this.#overrideSubtitleTrack) {
								this.#overrideSubtitleTrack = id;
								this.#sendMessage({
									event: 'overrideSubtitle',
									value: `${id}`
								});
							}
						}
					}
				}, 0, this.#source);
			}
		});
		if (this.#dom.audioTracks) {
			const audioTracks = this.#dom.audioTracks;
			audioTracks.addEventListener('change', () => {
				if (this.#state > 1 && !this.#shaka && !this.#audioOnChange) {
					this.#audioOnChange = setTimeout(source => {
						this.#audioOnChange = 0;
						if (this.#state > 1 && !this.#shaka && this.#source === source) {
							let id = -1,
								candidate = -1;
							const defaultTrack = this.#overrideAudioTrack < 0 ? this.#getDefaultTrack(1) : this.#overrideAudioTrack;
							for (let i = 0; i < audioTracks.length; i++) {
								if (audioTracks[i].enabled) {
									const trackId = VideoViewPlugin.#getTrackId(audioTracks, i);
									if (trackId === defaultTrack) {
										id = trackId;
										break;
									} else if (candidate < 0) {
										candidate = trackId;
									}
								}
							}
							if (id < 0 && candidate >= 0) {
								id = candidate;
							}
							if (id >= 0 && id !== this.#overrideAudioTrack && (this.#overrideAudioTrack >= 0 || id !== this.#getDefaultTrack(1))) {
								this.#overrideAudioTrack = id;
								this.#sendMessage({
									event: 'overrideAudio',
									value: `${id}`
								});
							}
						}
					}, 0, this.#source);
				}
			});
		}
		this.#state = 1;
		this.#source = url;
		let cType = '';
		const m = url.match(/\.(?:mpd|m3u8|ism\/manifest)/ig);
		if (m) {
			const types = {
				'.mpd': 'application/dash+xml',
				'.m3u8': 'application/x-mpegurl',
				'.ism/manifest': 'application/vnd.ms-sstr+xml'
			};
			cType = types[m[m.length - 1].toLowerCase()];
			if (globalThis.shaka && VideoViewPlugin.#hasMSE && (!VideoViewPlugin.#isApple || cType !== types['.m3u8'])) {
				this.#shaka = new shaka.Player();
			}
		}
		if (this.#shaka) {
			/** @param {shaka.util.Error} err */
			const sendError = err => {
				if (this.#state > 0 && err.severity === shaka.util.Error.Severity.CRITICAL) {
					const result = [];
					for (const n of ['Category', 'Code']) {
						const i = result.length,
							v = err[n.toLowerCase()];
						for (const k in shaka.util.Error[n]) {
							if (shaka.util.Error[n][k] === v) {
								result.push(k);
								break;
							}
						}
						if (result.length === i) {
							result.push(v);
						}
					}
					this.#sendError(`${result.join('.')}`);
				}
			};
			this.#configureShaka();
			this.#shaka.addEventListener('error', evt => sendError(evt.detail));
			this.#shaka.attach(this.#dom);
			this.#shaka.load(url, null, cType).catch(sendError);
		} else {
			if (cType && this.#dom.canPlayType(cType)) {
				const src = document.createElement('source');
				src.src = url;
				src.type = cType;
				this.#dom.appendChild(src);
			} else {
				this.#dom.src = url;
			}
			this.#dom.load();
		}
	}

	close() {
		if (this.#state > 0) {
			this.#close();
		}
	}

	play() {
		if (this.#state === 2) {
			this.#play();
		}
	}

	pause() {
		if (this.#state === 3) {
			this.#playTime = 0;
			this.#dom.pause();
		}
	}

	/**
	 * @param {number} position
	 * @param {boolean} fast
	 */
	seekTo(position, fast) {
		if (this.#state === 1) {
			this.#position = position;
		} else if (this.#state > 1) {
			if (fast && this.#dom.fastSeek) {
				this.#dom.fastSeek(position / 1000);
			} else {
				this.#dom.currentTime = position / 1000;
			}
		}
	}

	/** @param {number} volume */
	setVolume(volume) {
		if (volume > 1) {
			volume = 1;
		}
		this.#dom.volume = this.#volume = volume;
	}

	/** @param {number} speed */
	setSpeed(speed) {
		if (speed > 2) {
			speed = 2;
		} else if (speed < 0.5) {
			speed = 0.5;
		}
		this.#dom.playbackRate = this.#speed = speed;
	}

	/** @param {boolean} looping */
	setLooping(looping) {
		this.#looping = looping;
	}

	/** @param {boolean} autoPlay */
	setAutoPlay(autoPlay) {
		this.#autoPlay = autoPlay;
	}

	/** @param {0|1|2} mode */
	setDisplayMode(mode) {
		if (this.#state > 0) {
			if (VideoViewPlugin.#isApple) {
				const type = ['inline', 'fullscreen', 'picture-in-picture'][mode];
				if (this.#dom.webkitSupportsPresentationMode(type)) {
					if (this.#dom.webkitPresentationMode !== type) {
						this.#dom.webkitSetPresentationMode(type);
					}
					return true;
				}
			} else if (mode === 0) {
				if (document.fullscreenElement === this.#dom) {
					document.exitFullscreen();
				} else if (document.pictureInPictureElement === this.#dom) {
					document.exitPictureInPicture();
				}
				return true;
			} else {
				const type = mode === 1 ? 'fullscreen' : 'pictureInPicture';
				if (document[type + 'Enabled']) {
					if (document[type + 'Element'] !== this.#dom) {
						this.#dom['request' + type[0].toUpperCase() + type.slice(1)]();
					}
					return true;
				}
			}
		}
		return false;
	}

	/** @param {string} lang */
	setPreferredAudioLanguage(lang) {
		this.#preferredAudioLanguage = lang;
		if (this.#state > 1 && this.#overrideAudioTrack < 0) {
			this.#setAudioTrack();
		}
	}

	/** @param {string} lang */
	setPreferredSubtitleLanguage(lang) {
		this.#preferredSubtitleLanguage = lang;
		if (this.#state > 1 && this.#showSubtitle && this.#overrideSubtitleTrack < 0) {
			this.#setSubtitleTrack();
		}
	}

	/** @param {number} bitrate */
	setMaxBitrate(bitrate) {
		this.#maxBitrate = bitrate;
		if (this.#shaka) {
			this.#configureShaka();
		}
	}

	/**
	 * @param {number} width
	 * @param {number} height
	 */
	setMaxResolution(width, height) {
		this.#maxVideoWidth = width;
		this.#maxVideoHeight = height;
		if (this.#shaka) {
			this.#configureShaka();
		}
	}

	/** @param {boolean} show */
	setShowSubtitle(show) {
		this.#showSubtitle = show;
		this.#setSubtitleTrack();
	}

	/** @param {string?} trackId */
	setOverrideAudio(trackId) {
		this.#overrideAudioTrack = trackId === null ? -1 : +trackId;
		this.#setAudioTrack();
	}

	/** @param {string?} trackId */
	setOverrideSubtitle(trackId) {
		this.#overrideSubtitleTrack = trackId === null ? -1 : +trackId;
		this.#setSubtitleTrack();
	}

	/**
	 * @param {number} backgroundColor
	 * @param {string} objectFit
	 * */
	setStyle(objectFit, backgroundColor) {
		if (typeof backgroundColor === 'number') {
			const s = backgroundColor.toString(16).padStart(8, '0'),
				m = s.match(/^(.{2})(.{6})$/); // argb to rgba
			this.#dom.style.backgroundColor = `#${m[2]}${m[1]}`;
		}
		if (typeof objectFit === 'string') {
			if (objectFit === 'scaleDown') {
				objectFit = 'scale-down';
			}
			if (objectFit === 'fitWidth' || objectFit === 'fitHeight') {
				this.#fitWidth = objectFit === 'fitWidth';
				if (!this.#observer) {
					this.#observer = new ResizeObserver(entries => {
						this.#dom.width = Math.round(entries[0].contentBoxSize[0].inlineSize * devicePixelRatio * visualViewport.scale);
						this.#dom.height = Math.round(entries[0].contentBoxSize[0].blockSize * devicePixelRatio * visualViewport.scale);
						this.#onresize();
					});
					this.#observer.observe(this.#dom);
				} else if (this.#dom.width > 0 && this.#dom.height > 0) {
					this.#onresize();
				}
			} else {
				this.#dom.style.objectFit = objectFit;
				if (this.#observer) {
					this.#observer.unobserve(this.#dom);
					this.#observer = null;
					this.#dom.removeAttribute('width');
					this.#dom.removeAttribute('height');
				}
			}
		}
	}
};
Object.freeze(VideoViewPlugin.prototype);
Object.freeze(VideoViewPlugin);