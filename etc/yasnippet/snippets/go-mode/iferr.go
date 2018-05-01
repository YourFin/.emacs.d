# -*- mode: snippet -*-
# name: iferr
# key: /fe
# --
if ${1:err} != nil {
	${2:log.Fatal}(err)
}$0