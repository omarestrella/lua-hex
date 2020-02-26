package.path = package.path..';'..os.getenv('HOME')..'/Documents/?.lua'
import = function(module)
    local proj, file = string.match(module, '(.+)/(.+)')
    local proj_path = '/Documents/'..proj
    
    if proj and not string.find(package.path, proj_path) then
        package.path = package.path..';'..os.getenv('HOME')..proj_path..'.codea/?.lua'
    end
    return require(file and file or module)
end