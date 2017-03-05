/*
 * Modules
 **/
const path = require("path");
const webpack = require("webpack");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const autoprefixer = require("autoprefixer");
const merge = require('webpack-merge');
const validate = require('webpack-validator');

/*
 * Environment
 **/
const env = process.env.MIX_ENV || 'dev';
const dev = env === "dev";
const app_path = (...dirs) => path.join(__dirname, ...dirs);
const paths = {
  build: app_path("../priv/static"),
  js: app_path("js"),
  images: app_path("static/images"),
  fonts: app_path("static/fonts"),
  modules: [
    app_path("node_modules/react"),
    app_path("node_modules/react-dom"),
    app_path("node_modules/phoenix"),
    app_path("node_modules/phoenix_html")
  ]
};

/*
 * Common Config
 **/
const common = {
  devtool: 'cheap-module-eval-source-map',

  output: {
    path: paths.build,
    filename: 'js/[name].js',
    publicPath: 'http://localhost:8080/'
  },

  module: {
    loaders: [
      {
        test: /\.(jsx?)$/,
        loaders: ["babel"],
        exclude: /node_modules/,
        include: paths.modules.concat(paths.js)
      },

      {
        test: /\.styl$|\.css$/,
        loader: dev ? "style!css!postcss!stylus" : ExtractTextPlugin.extract("style", "css!postcss!stylus")
      },

      {
        test: /\.(png|jpe?g|gif|svg)$/,
        loader: "file-loader",
        query: { name: "images/[hash].[ext]" },
        exclude: /node_modules/,
        include: paths.images
      },

      {
        test: /\.(ttf|woff2?|eot|svg)$/,
        loader: "file-loader",
        query: { name: "fonts/[hash].[ext]" },
        exclude: /node_modules/,
        include: paths.fonts
      }
    ]
  },

  resolve: {
    extensions: ["", ".js", ".jsx", ".css", ".styl"]
  },

  plugins: dev ? [
    new ExtractTextPlugin("css/[name].css")
  ] : [
    new ExtractTextPlugin("css/[name].css"),
    new webpack.optimize.UglifyJsPlugin({ 
      compress: { warnings: false },
      output: { comments: false }
    })
  ],

  postcss: [
    autoprefixer({
      browsers: ["last 2 versions"]
    })
  ]
};

const configs = [
  {
    entry: {
      app: [
        "./js/app.js",
        "./stylus/app.styl"
      ]
    }
  }
];

module.exports = configs.map(config => {
  return validate(merge(common, config));
});
