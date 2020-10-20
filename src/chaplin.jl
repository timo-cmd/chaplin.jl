# tbd soon
module Chaplin

export
ChaplinRequest,
ChaplinServer,
after,
before,
delete,
get,
patch,
post,
put,
render_template,
route,
start,
unroute

include("log.jl")
include("request.jl")
include("route.jl")
include("server.jl")
include("template.jl")

server = ChaplinServer(Nullable{Function}(), Nullable{Function}(), Array{route, 1}())

end
