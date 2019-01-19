---
title: VSCode插件及配置
author: Deepspace
categories: Tool
date: 2019-01-16
urlname: vscode-plugins-and-configurations
---
<!-- ## VSCode插件及配置 -->

> 一直把 `VSCode` 作为前端开发编辑器，非常好用。因为装的插件和自定义配置较多，这里做个备份备忘。

#### 一、插件

```
- advanced-new-file
- Docker
- ESLint
- HTML Snippets
- JavaScript（ES6）code snippets
- Markdown All in One
- Material Theme
- Path Intellisense
- Prettier - Code formatter
- React Standard Style code snippets
- Vetur
```

<!-- more -->

#### 二、VSCode 配置 React

`VSCode` 自带了 `Emmet`，可以自动补全 `HTML` 文件中的标签，想要补全 `react` 文件中 `JSX` 里面的标签，需要在用户设置中增加 `Emmet` 的设置：

##### 1、配置emmet

```json
{
    "emmet.includeLanguages": {
        "javascript": "javascriptreact"
    },
    "emmet.triggerExpansionOnTab": true
}
```

##### 2、代码片段生成插件：

安装插件： `React Standard Style code snippets`



#### 三、VSCode 配置 Vue

##### 1、vue 文件的基本语法高亮

安装插件：`vetur` .

安装完  `vetur`  后还需要在自定义配置文件中加上如下配置：

```json
{
    "emmet.includeLanguages": {
        "vue-html": "html",
        "javascript": "javascriptreact"
    },
    "emmet.syntaxProfiles": {
        "vue-html": "html",
        "vue": [
            "css",
            "html",
            "less"
        ]
    },
    "vetur.format.defaultFormatter.js": "vscode-typescript",
    "vetur.format.defaultFormatter.html": "js-beautify-html",
    "vetur.format.defaultFormatterOptions": {
        "wrap_attributes": "force-aligned",
        "js-beautify-html": {
            "wrap_attributes": "force-expand-multiline"
        },
        "prettyhtml": {
            "printWidth": 100,
            "singleQuote": true,
            "wrapAttributes": false,
            "sortAttributes": false
        }
    }
}
```

##### 2、 vue 文件的 ESLint

安装插件：`ESLint` ，`ESLint` 不是安装后就可以用的，还需要其他的一些环境和配置：

- 全局安装 `ESLint` :

  ```shell
  $ npm install -g eslint
  ```

- `vue` 文件是类 `HTML` 的文件，为了支持对 `vue` 文件的 `ESLint` ，需要 `eslint-plugin-html` 这个插件：

  ```shell
  $ npm install -g eslint-plugin-html
  ```

  安装好之后，在自定义配置文件中加上如下配置：

  ```json
  {
      "eslint.options": {
          "plugins": [
              "html"
          ]
      },
      "eslint.validate": [
          "javascript",
          "javascriptreact",
          "html",
          "vue",
          {
              "language": "html",
              "autoFix": true
          },
          {
              "language": "vue",
              "autoFix": true
          }
      ]
  }
  ```

  此时，`eslint` 会根据项目根目录下的 `.eslintrc.json`  文件（没有需要创建）进行代码检查。



#### 四、代码格式化

安装插件 `prettier` , 配置如下（可根据项目遵循的规则自行配置）：

```json
{
    "prettier.disableLanguages": [],
    "prettier.semi": true,
    "prettier.singleQuote": true,
    "prettier.jsxSingleQuote": true,
    "prettier.trailingComma": "all"
}
```



#### 五、用户自定义配置文件

```json
{
    "workbench.startupEditor": "newUntitledFile",
    "terminal.external.osxExec": "iTerm.app",
    "explorer.confirmDelete": false,
    "terminal.integrated.fontFamily": "Source Code Pro for Powerline",
    "terminal.integrated.fontSize": 14,
    "editor.fontSize": 14,
    "editor.fontWeight": "500",
    "editor.fontFamily": "Source Code Pro, 'Courier New', monospace",
    "editor.formatOnSave": true,
    "editor.multiCursorModifier": "ctrlCmd",
    "editor.formatOnPaste": true,
    "window.zoomLevel": 0,
    "emmet.includeLanguages": {
        "vue-html": "html",
        "javascript": "javascriptreact"
    },
    "emmet.syntaxProfiles": {
        "vue-html": "html",
        "vue": [
            "css",
            "html",
            "less"
        ]
    },
    "explorer.confirmDragAndDrop": false,
    "files.trimFinalNewlines": true,
    "files.associations": {
        "*.vue": "vue"
    },
    "files.insertFinalNewline": true,
    "files.autoSave": "onFocusChange",
    "prettier.disableLanguages": [],
    "prettier.semi": true,
    "prettier.singleQuote": true,
    "prettier.jsxSingleQuote": true,
    "prettier.trailingComma": "all",
    "eslint.options": {
        "plugins": [
            "html"
        ]
    },
    "eslint.validate": [
        "javascript",
        "javascriptreact",
        "html",
        "vue",
        {
            "language": "html",
            "autoFix": true
        },
        {
            "language": "vue",
            "autoFix": true
        }
    ],
    "vetur.format.defaultFormatter.js": "prettier",
    "vetur.format.defaultFormatter.html": "js-beautify-html",
    "vetur.format.defaultFormatterOptions": {
        "wrap_attributes": "force-aligned",
        "js-beautify-html": {
            "wrap_attributes": "force-expand-multiline"
        },
        "prettyhtml": {
            "printWidth": 100,
            "singleQuote": true,
            "wrapAttributes": false,
            "sortAttributes": false
        }
    },
    "javascript.format.insertSpaceBeforeFunctionParenthesis": true
}
```
