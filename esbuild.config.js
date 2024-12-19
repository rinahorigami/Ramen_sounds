const esbuild = require('esbuild');

esbuild.build({
  entryPoints: ['app/javascript/admin.js'], // エントリーポイント
  bundle: true,
  outfile: 'app/assets/builds/admin.js',    // 出力ファイル
  treeShaking: true, 
  minify: true,
  sourcemap: true,
  loader: {
    '.css': 'text', // CSSはJavaScriptに埋め込む
  },
}).catch(() => process.exit(1));
