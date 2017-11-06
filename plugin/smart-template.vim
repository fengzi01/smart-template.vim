" 
" Smart-Template
"
" @author fengyuwei<fengyuwei01@gmail.com>
" 
"

if exists('g:smart_template_plugin_loaded') 
    finish
endif

let g:smart_template_plugin_loaded = 1

" init 
" 用户信息 
if !exists('g:user_name') 
    let g:user_name = "none"
endif
if !exists('g:user_email')
    let g:user_email = "none@none.domain"
endif

" 搜索目录(array)
if !exists('g:smart_template_dir') 
    let g:smart_template_dir = [];
endif 

if !exists('g:smart_template_module_mode')
    let g:smart_template_module_mode = 0
endif

" 模块名 仅当 module_mode下有效
if !exists('g:smart_template_module_name')
    let g:smart_template_module_name = 'work'
endif
    

" 模板文件
if !exists('g:smart_template_name')
    let g:smart_template_name = "template"
endif

" 用户自定义变量
if !exists('g:smart_template_custom_variables') 
    let g:smart_template_custom_variables = {};
endif 

" debug
function <SID>StDebug(msg)
    if g:smart_template_debug
        echom(msg)
    endif
endfunction

" 加载配置 & 搜索配置文件
" TODO
function <SID>StLoadConf() 

endfunction

" TODO
function <SID>StSearchCache()
endfunction

function <SID>StSearchTemplate(tDir,tName,suffix,mode)
    let l:filePath = a:tDir . a:tName . a:suffix
    StDebug("found template file in:" . l:filePath)
    if filereadable(l:filePath) 
        return l:filePath
    endif

    StDebug("template file is no exist." . l:filePath)
    return ""
endfunction

function <SID>EscapeRegex(raw)
    return escape(a:raw, '/')
endfunction

function <SID>StDoRenderVar(variable,value,flag) 
    silent! execute "%s/\\V%" . <SID>EscapeRegex(a:variable) . "%/" .  <SID>EscapeRegex(a:value) . "/g"
endfunction

function <SID>StRenderHere()
    0  " Go to first line before searching
    if search("%HERE%", "W")
        let l:column = col(".")
        let l:lineno = line(".")
        s/%HERE%//
        call cursor(l:lineno, l:column)
    endif
endfunction

" 渲染变量
function <SID>StRenderVars()
    let l:day        = strftime("%d")
    let l:year       = strftime("%Y")
    let l:month      = strftime("%m")
    let l:monshort   = strftime("%b")
    let l:monfull    = strftime("%B")
    let l:time       = strftime("%H:%M")
    let l:date       = exists("g:dateformat") ? strftime(g:dateformat) :
                     \ (l:year . "-" . l:month . "-" . l:day)
    let l:fdate      = l:date . " " . l:time
    let l:filen      = expand("%:t:r:r:r")
    let l:filex      = expand("%:e")
    let l:filec      = expand("%:t")
    let l:fdir       = expand("%:p:h:t")
    let l:hostn      = hostname()
    let l:user       = g:user_name
    let l:email      = g:user_email
    let l:guard      = toupper(substitute(l:filec, "[^a-zA-Z0-9]", "_", "g"))
    let l:class      = substitute(l:filen, "\\([a-zA-Z]\\+\\)", "\\u\\1\\e", "g")
    let l:macroclass = toupper(l:class)
    let l:camelclass = substitute(l:class, "_", "", "g")

    call <SID>StDoRenderVar("DAY",   l:day)
    call <SID>StDoRenderVar("YEAR",  l:year)
    call <SID>StDoRenderVar("DATE",  l:date)
    call <SID>StDoRenderVar("TIME",  l:time)
    call <SID>StDoRenderVar("USER",  l:user)
    call <SID>StDoRenderVar("FDATE", l:fdate)
    call <SID>StDoRenderVar("MONTH", l:month)
    call <SID>StDoRenderVar("MONTHSHORT", l:monshort)
    call <SID>StDoRenderVar("MONTHFULL",  l:monfull)
    call <SID>StDoRenderVar("FILE",  l:filen)
    call <SID>StDoRenderVar("FFILE", l:filec)
    call <SID>StDoRenderVar("FDIR",  l:fdir)
    call <SID>StDoRenderVar("EXT",   l:filex)
    call <SID>StDoRenderVar("MAIL",  l:email)
    call <SID>StDoRenderVar("HOST",  l:hostn)
    call <SID>StDoRenderVar("GUARD", l:guard)
    call <SID>StDoRenderVar("CLASS", l:class)
    call <SID>StDoRenderVar("MACROCLASS", l:macroclass)
    call <SID>StDoRenderVar("CAMELCLASS", l:camelclass)
    call <SID>StDoRenderVar("LICENSE", exists("g:license") ? g:license : "MIT")

    " set here
    call <SID>StRenderHere

endfunction

" 加载模板主函数
function <SID>StDoTemplate(template,position) 
    if a:template == ""
        return ""
    endif

    let l:fileEmpty = 0 
    if line("$") == 1 && getLine(1) == ''
        let l:fileEmpty = 1
    endif 

    if a:position = 0 || l:emptyFile = 1
        " 在文件开头添加
        execute "keepalt 0r " . l:template
    endif 

    " 渲染模板
    call StRenderVars()
endfunction

function <SID>StTemplate()
    let l:template = <SID>StSearchTemplate(g:smart_template_dir,g:smart_template_name,".cc")

    call StRenderVars(template,0)
endfunction

if g:smart_template_autocmd
    augroup Templating
        autocmd!
        autocmd BufNewFile * call <SID>StTemplate()
    augroup END
endif
command! -nargs=0 SmartTemplate call StTemplate()
