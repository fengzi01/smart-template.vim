# smart-template.vim
vim 模板插件
一个重复造轮子的项目 
## 设计目标

 - 基本模板功能
    - 按照文件后缀名搜索模板文件
    - 支持用户名、用户邮箱等模板变量替换
    - 暴露一个接口 SmartTemplate 用来替换模板文件
    - 暴露几个配置变量

 - 扩展功能(TODO)
    - cache 功能
    - 多套模板，支持在项目下定义配置文件
    - 递归遍历，生成项目头文件

## 致谢    
本插件受到下面项目启发:

 [aperezdc/vim-template](https://github.com/aperezdc/vim-template)

 [hotoo/template.vim](https://github.com/hotoo/template.vim)

