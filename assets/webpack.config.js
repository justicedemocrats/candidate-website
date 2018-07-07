/*
 * Modules
 **/
const path = require("path");
const webpack = require("webpack");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const autoprefixer = require("autoprefixer");


/*
 * Configuration
 **/
module.exports = (env) => {
  const isDev = !(process.env.MIX_ENV && process.env.MIX_ENV == 'prod');
  const devtool = isDev ? "eval" : "source-map";

  console.log(isDev)

  return {
    devtool: devtool,

    context: __dirname,

    entry: {
      styles: ["stylus/app.styl"],
      app: ["js/app.js"],
    },

    output: {
      path: path.resolve(__dirname, "../priv/static"),
      filename: 'js/[name].js',
      publicPath: 'http://localhost:8080/'
    },

    devServer: {
      headers: {
        "Access-Control-Allow-Origin": "*",
      }
    },

    module: {
      rules: [
        {
          test: /\.(jsx?)$/,
          exclude: /node_modules/,
          loader: "babel-loader"
        },

        {
          test: /\.(gif|png|jpe?g|svg)$/i,
          exclude: /node_modules/,
          loaders: [
            'file-loader?name=images/[name].[ext]',
            {
              loader: 'image-webpack-loader',
              options: {
                query: {
                  mozjpeg: {
                    progressive: true,
                  },
                  gifsicle: {
                    interlaced: true,
                  },
                  optipng: {
                    optimizationLevel: 7,
                  },
                  pngquant: {
                    quality: '65-90',
                    speed: 4
                  }
                }
              }
            }
          ]
        },

        {
          test: /\.(ttf|woff2?|eot|svg)$/,
          exclude: /node_modules/,
          options: {
            name: "[name].[ext]",
            publicPath: '/',
            outputPath: 'fonts/'
          },
          loader: "file-loader"
        },

        {
          test: /\.(css|styl)$/,
          exclude: /node_modules/,
          use: isDev ? [
            "style-loader",
            "css-loader",
            "stylus-loader"
          ] : ExtractTextPlugin.extract({
            fallback: "style-loader",
            use: ["css-loader", "stylus-loader"]
          })
        }
      ]
    },

    resolve: {
      modules: ["node_modules", __dirname],
      extensions: [".js", ".json", ".jsx", ".css", ".styl"],
      alias: {
        'shoelace.css': path.join(__dirname, 'node_modules/shoelace-css/dist/shoelace.css'),
      }
    },

    plugins: isDev ? [
      new CopyWebpackPlugin([{
        from: "./static",
        to: path.resolve(__dirname, "../priv/static")
      }])
    ] : [
      new CopyWebpackPlugin([{
        from: "./static",
        to: path.resolve(__dirname, "../priv/static")
      }]),

      new ExtractTextPlugin({
        filename: "css/[name].css",
        allChunks: true
      }),

      new webpack.optimize.UglifyJsPlugin({
        sourceMap: true,
        beautify: false,
        comments: false,
        extractComments: false,
        compress: {
          warnings: false,
          drop_console: true
        },
        mangle: {
          except: ['$'],
          screw_ie8 : true,
          keep_fnames: true,
        }
      })
    ]
  };
};
