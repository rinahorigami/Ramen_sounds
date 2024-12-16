const esbuild = require('esbuild');

esbuild.build({
  entryPoints: ['app/javascript/admin.css'], // CSSエントリポイント
  outfile: 'app/assets/builds/admin.css',    // 出力先
  bundle: true,                              // モジュールをバンドル
  loader: {
    '.css': 'css',
    '.woff': 'file',                         // フォントファイルのローダー
    '.woff2': 'file',
    '.eot': 'file',
    '.ttf': 'file',
    '.svg': 'file',
  },
  minify: true,                              // 圧縮
  resolveExtensions: ['.css'],               // 拡張子解決
}).catch(() => process.exit(1));