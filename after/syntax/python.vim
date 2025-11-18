syn keyword pythonBuiltinConst False True None

syn match pythonConst "\v<_*[A-Z]+[A-Z0-9_]*>"

syn match pythonSelf "\v<self>"
syn match pythonCls "\v<cls>"

syn match pythonFStringF "\m\zs[frb]\ze\""
syn match pythonFStringCurly "\v\zs\{.{-}\}\ze" contained contains=pythonFStringInner
syn match pythonFStringInner "\v\{\zs.{-}\ze\}"

syn match pythonDot "\v[\.\:\,]"
syn match pythonArrow " -> "

syn match pythonArg "\v\zs\w+\ze\="
syn match pythonAddlOperator "\v[\=\+\*\-\/\\\|\!]"

syn match pythonParen "\v[\(\)\{\}\[\]]"



