// Modules
const path = require("path");
const webpack = require("webpack");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const autoprefixer = require("autoprefixer");

// Constants
const env = process.env.MIX_ENV || 'dev';
const dev = env === "dev";

// Configuration
const config = {
  devtool: 'cheap-module-eval-source-map',

  entry: {
    app: [
      "./web/static/js/app.js",
      "./web/static/stylus/app.styl"
    ]
  },

  output: {
    path: path.resolve(__dirname, "priv/static"),
    filename: 'js/[name].js',
    publicPath: 'http://localhost:8080/'
  },

  module: {
    loaders: [
      {
        test: /\.(jsx?)$/,
        loaders: ["babel"],
        exclude: /node_modules/
      },

      {
        test: /\.styl$|\.css$/,
        loader: dev ? "style!css!postcss!stylus" : ExtractTextPlugin.extract("style", "css!postcss!stylus")
      },

      {
        test: /\.(png|jpe?g|gif|svg)$/,
        loader: "file-loader",
        query: { name: "images/[hash].[ext]" }
      },

      {
        test: /\.(ttf|woff2?|eot|svg)$/,
        loader: "file-loader",
        query: { name: "fonts/[hash].[ext]" }
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
      browsers: [
        "last 2 version",
        "> 5%",
        "IE 9-11"
      ]
    })
  ]
};

module.exports = config;
