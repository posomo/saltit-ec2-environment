function fail(msg)
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say(msg)
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end


-- 시퀀스 값을 반환하는 함수
function get_sequence()
    -- 락 획득
    local resty_lock = require "resty.lock"
    local lock_name = "sequence_lock"
    local key = "sequence"
    local seq_number = ngx.shared.seq


    local lock, err = resty_lock:new(lock_name)
    if not lock then
        return fail("failed to create lock " .. err)
    end

    local elapsed, err = lock:lock(key)
    if not elapsed then
        return fail("failed to acquire the lock " .. err)
    end

    local val, err = seq_number:incr(key, 1, 0, 0.1)
    local ok, err = lock:unlock()
    if not ok then
        return fail("failed to unlock " .. err)
    end
    return val
end


-- 요청마다 시퀀스 값을 반환하는 함수 호출
local sequence = string.format("%05d", get_sequence())
local curTime = os.time() + 9 * 60 * 60;
local date_time = os.date('%Y%m%d%H%M%S', curTime)
local transaction_id = date_time .. sequence
-- 시퀀스 값을 헤더에 설정
ngx.req.set_header("X-Transaction-Id", transaction_id)