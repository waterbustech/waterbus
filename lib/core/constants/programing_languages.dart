import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/ada.dart';
import 'package:re_highlight/languages/awk.dart';
import 'package:re_highlight/languages/bash.dart';
import 'package:re_highlight/languages/c.dart';
import 'package:re_highlight/languages/clojure.dart';
import 'package:re_highlight/languages/cmake.dart';
import 'package:re_highlight/languages/cpp.dart';
import 'package:re_highlight/languages/css.dart';
import 'package:re_highlight/languages/d.dart';
import 'package:re_highlight/languages/dart.dart';
import 'package:re_highlight/languages/dockerfile.dart';
import 'package:re_highlight/languages/elixir.dart';
import 'package:re_highlight/languages/erlang.dart';
import 'package:re_highlight/languages/fortran.dart';
import 'package:re_highlight/languages/fsharp.dart';
import 'package:re_highlight/languages/go.dart';
import 'package:re_highlight/languages/graphql.dart';
import 'package:re_highlight/languages/groovy.dart';
import 'package:re_highlight/languages/haskell.dart';
import 'package:re_highlight/languages/java.dart';
import 'package:re_highlight/languages/javascript.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/languages/julia.dart';
import 'package:re_highlight/languages/kotlin.dart';
import 'package:re_highlight/languages/less.dart';
import 'package:re_highlight/languages/lisp.dart';
import 'package:re_highlight/languages/lua.dart';
import 'package:re_highlight/languages/makefile.dart';
import 'package:re_highlight/languages/markdown.dart';
import 'package:re_highlight/languages/nginx.dart';
import 'package:re_highlight/languages/objectivec.dart';
import 'package:re_highlight/languages/ocaml.dart';
import 'package:re_highlight/languages/perl.dart';
import 'package:re_highlight/languages/php.dart';
import 'package:re_highlight/languages/powershell.dart';
import 'package:re_highlight/languages/prolog.dart';
import 'package:re_highlight/languages/puppet.dart';
import 'package:re_highlight/languages/python.dart';
import 'package:re_highlight/languages/r.dart';
import 'package:re_highlight/languages/ruby.dart';
import 'package:re_highlight/languages/rust.dart';
import 'package:re_highlight/languages/scala.dart';
import 'package:re_highlight/languages/scheme.dart';
import 'package:re_highlight/languages/scss.dart';
import 'package:re_highlight/languages/shell.dart';
import 'package:re_highlight/languages/smalltalk.dart';
import 'package:re_highlight/languages/sql.dart';
import 'package:re_highlight/languages/swift.dart';
import 'package:re_highlight/languages/taggerscript.dart';
import 'package:re_highlight/languages/tcl.dart';
import 'package:re_highlight/languages/verilog.dart';
import 'package:re_highlight/languages/vhdl.dart';
import 'package:re_highlight/languages/xml.dart';
import 'package:re_highlight/languages/yaml.dart';

final programmingLanguages = [
  {'c': CodeHighlightThemeMode(mode: langC)},
  {'c++': CodeHighlightThemeMode(mode: langCpp)},
  {'java': CodeHighlightThemeMode(mode: langJava)},
  {'python': CodeHighlightThemeMode(mode: langPython)},
  {'javascript': CodeHighlightThemeMode(mode: langJavascript)},
  {'swift': CodeHighlightThemeMode(mode: langSwift)},
  {'ruby': CodeHighlightThemeMode(mode: langRuby)},
  {'php': CodeHighlightThemeMode(mode: langPhp)},
  {'go': CodeHighlightThemeMode(mode: langGo)},
  {'typescript': CodeHighlightThemeMode(mode: langTaggerscript)},
  {'rust': CodeHighlightThemeMode(mode: langRust)},
  {'kotlin': CodeHighlightThemeMode(mode: langKotlin)},
  {'scala': CodeHighlightThemeMode(mode: langScala)},
  {'perl': CodeHighlightThemeMode(mode: langPerl)},
  {'lua': CodeHighlightThemeMode(mode: langLua)},
  {'haskell': CodeHighlightThemeMode(mode: langHaskell)},
  {'r': CodeHighlightThemeMode(mode: langR)},
  {'bash': CodeHighlightThemeMode(mode: langBash)},
  {'sql': CodeHighlightThemeMode(mode: langSql)},
  {'objective-c': CodeHighlightThemeMode(mode: langObjectivec)},
  {'css': CodeHighlightThemeMode(mode: langCss)},
  {'less': CodeHighlightThemeMode(mode: langLess)},
  {'scss': CodeHighlightThemeMode(mode: langScss)},
  {'graphql': CodeHighlightThemeMode(mode: langGraphql)},
  {'json': CodeHighlightThemeMode(mode: langJson)},
  {'yaml': CodeHighlightThemeMode(mode: langYaml)},
  {'xml': CodeHighlightThemeMode(mode: langXml)},
  {'markdown': CodeHighlightThemeMode(mode: langMarkdown)},
  {'shell': CodeHighlightThemeMode(mode: langShell)},
  {'powershell': CodeHighlightThemeMode(mode: langPowershell)},
  {'fortran': CodeHighlightThemeMode(mode: langFortran)},
  {'lisp': CodeHighlightThemeMode(mode: langLisp)},
  {'scheme': CodeHighlightThemeMode(mode: langScheme)},
  {'erlang': CodeHighlightThemeMode(mode: langErlang)},
  {'clojure': CodeHighlightThemeMode(mode: langClojure)},
  {'elixir': CodeHighlightThemeMode(mode: langElixir)},
  {'ocaml': CodeHighlightThemeMode(mode: langOcaml)},
  {'f#': CodeHighlightThemeMode(mode: langFsharp)},
  {'julia': CodeHighlightThemeMode(mode: langJulia)},
  {'groovy': CodeHighlightThemeMode(mode: langGroovy)},
  {'dart': CodeHighlightThemeMode(mode: langDart)},
  {'ada': CodeHighlightThemeMode(mode: langAda)},
  {'verilog': CodeHighlightThemeMode(mode: langVerilog)},
  {'vhdl': CodeHighlightThemeMode(mode: langVhdl)},
  {'tcl': CodeHighlightThemeMode(mode: langTcl)},
  {'prolog': CodeHighlightThemeMode(mode: langProlog)},
  {'smalltalk': CodeHighlightThemeMode(mode: langSmalltalk)},
  {'ada': CodeHighlightThemeMode(mode: langAda)},
  {'awk': CodeHighlightThemeMode(mode: langAwk)},
  {'fortran': CodeHighlightThemeMode(mode: langFortran)},
  {'d': CodeHighlightThemeMode(mode: langD)},
  {'f#': CodeHighlightThemeMode(mode: langFsharp)},
  {'julia': CodeHighlightThemeMode(mode: langJulia)},
  {'groovy': CodeHighlightThemeMode(mode: langGroovy)},
  {'puppet': CodeHighlightThemeMode(mode: langPuppet)},
  {'cmake': CodeHighlightThemeMode(mode: langCmake)},
  {'nginx': CodeHighlightThemeMode(mode: langNginx)},
  {'makefile': CodeHighlightThemeMode(mode: langMakefile)},
  {'dockerfile': CodeHighlightThemeMode(mode: langDockerfile)},
  {'powershell': CodeHighlightThemeMode(mode: langPowershell)},
];
