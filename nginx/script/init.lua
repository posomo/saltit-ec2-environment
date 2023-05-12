-- Lua 코드가 처음 로드될 때 실행되는 함수
-- 여기서 shared.DICT를 초기화한다.

local sequence = ngx.shared.seq
sequence:set("sequence", 0)
