local cjson = require "cjson"
local pg = require("resty.postgres")
local db = pg:new()

db:set_timeout(3000)

local db_host = os.getenv("DATABASE_HOST")
local db_name = os.getenv("DATABASE_NAME")
local db_user = os.getenv("DATABASE_USER")
local db_pass = os.getenv("DATABASE_PASS")
local deploy_root_path = os.getenv("DEPLOY_ROOT_FOLDER")

local ok, err = db:connect({
  host=db_host,
  port=5432,
  database=db_name,
  user=db_user,
  password=db_pass,
  compact=false
})

if not ok then
  ngx.say("Not connected to DB")
  ngx.say(err)
end

-- Host that is sent to us through nginx
local host = ngx.var.http_host
ngx.var.franklin_pages_host = host


local res, err = db:query("SELECT path FROM builder_build b, builder_environment e WHERE e.url='" .. host .. "' AND b.status='SUC' ORDER BY b.created DESC LIMIT 1")

if not res[1] then
  ngx.status = ngx.HTTP_NOT_FOUND
  ngx.header["Content-type"] = "text/html"
  ngx.say(res)
  ngx.exit(0)
end

-- Commented out lines MAY be needed
-- local path = deploy_root_path .. res[1]["path"] .. string.sub(uri,1,-2)
local path = deploy_root_path .. res[1]["path"]
-- ngx.var.franklin_pages_uri = uri
ngx.var.franklin_pages_path = path
