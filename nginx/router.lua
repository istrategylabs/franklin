local cjson = require "cjson"
local pg = require("resty.postgres")
local db = pg:new()

db:set_timeout(3000)

local db_host = os.getenv("DATABASE_HOST")
local db_name = os.getenv("DATABASE_NAME")
local db_user = os.getenv("DATABASE_USER")
local db_pass = os.getenv("DATABASE_PASS")

local ok, err = db:connect({
  host=db_host,
  port=5432,
  database=db_name,
  user=db_user,
  password=db_pass,
  compact=false
})

if not ok then
  ngx.say(err)
end

-- Host that is sent to us through nginx
local host = ngx.var.http_host
ngx.var.franklin_pages_host = host

local res, err = db:query("SELECT path FROM builder_site WHERE url='" .. host .. "'")

local path = res[1]["path"]
ngx.var.franklin_pages_path = path
