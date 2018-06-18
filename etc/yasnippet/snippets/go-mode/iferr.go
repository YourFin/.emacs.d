# -*- mode: snippet -*-
# name: iferr
# key: /fe
# --
if ${1:err} != nil {
	${2:log.Fatal}("${3:CONTEXT} err: ", err)
}$0