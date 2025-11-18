if exists("b:current_syntax")
    finish
endif


"" General

syn match specComment "^\s*#.*$" contains=@Spell


"" Preamble tags

syntax match specPreambleTag "^\(Prereq\|Summary\|Name\|Version\|Packager\):" contains=@NoSpell
syntax match specPreambleTag "^\(Requires\|Recommends\|Suggests\|Supplements\):" contains=@NoSpell
syntax match specPreambleTag "^\(Enhances\|Icon\|URL\|SourceLicense\):" contains=@NoSpell
syntax match specPreambleTag "^\(Source\d*\|Patch\d*\|Prefix\|Packager\|Group\):" contains=@NoSpell
syntax match specPreambleTag "^\(License\|Release\|BuildRoot\|Distribution\):" contains=@NoSpell
syntax match specPreambleTag "^\(Vendor\|Provides\|ExclusiveArch\|ExcludeArch\):" contains=@NoSpell
syntax match specPreambleTag "^\(ExclusiveOS\|Obsoletes\|BuildArch\|BuildArchitectures\):" contains=@NoSpell
syntax match specPreambleTag "^\(BuildRequires\|BuildConflicts\|BuildPreReq\|Conflicts\):" contains=@NoSpell
syntax match specPreambleTag "^\(AutoRequires\|AutoReq\|AutoReqProv\|AutoProv\|Epoch\):" contains=@NoSpell


"" Sections

syn match specSection "^%\(package\|files\)"


"" Description section

syn match specDescription "^%description" contained
syn region specDescriptionRegion start=+^%description+ end=+^%+me=e-1 contains=@Spell,specDescription


"" Directives

syn match specDirective "%\(setup\|attrib\|defattr\|attr\|dir\|config\|docdir\|doc\|lang\|license\|verify\|ghost\|exclude\)\>" contains=@NoSpell


"" Scripts

syn match specScript "^%\(prep\|build\|install\|clean\|check\|preun\|pre\|postun\|posttrans\|post\)" contains=@NoSpell


"" Shell

syn match shellVariable "${\?[A-Za-z0-9_]\+}\?"
syn region shellString start=+"+ end=+"+ skip=+\\"+ contains=@Spell,shellVariable,specMacro

syn keyword shellKeyword if then else elif fi case esac for select while until do done in function time
syn keyword shellCommand cat chmod chown clear cp echo ln mkdir mv rm rmdir sed touch useradd usermod getent sed tar find


"" Macros

syn match specMacro "%{.\{-1,}}" contains=@NoSpell


"" Highlights

highlight link shellCommand             Statement
highlight link shellKeyword             Function
highlight link shellString              String
highlight link shellVariable            PreProc

highlight link specComment              Comment
highlight link specDescription          Statement
highlight link specDescriptionRegion    Constant
highlight link specDirective            Function
highlight link specMacro                PreProc
highlight link specPreAmbleSubSection   Statement
highlight link specPreambleTag          Statement
highlight link specScript               Statement
highlight link specSection              Statement

let b:current_syntax = "spec"
