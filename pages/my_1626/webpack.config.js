var webpack = require('webpack');
var path = require('path');

var globalWebpacklConfig = {
  componentSrcPath:      path.resolve(__dirname, 'source/component'),
  viewSrcPath:           path.resolve(__dirname, 'source/view'),
  jsDebugPath:           '../../../tpl/hi1626/v2/js/debug',
  jsDistPath:            '../../../tpl/hi1626/v2/js'
};

var config = {
  entry: globalWebpacklConfig.viewSrcPath + '/layout.jsx',
  output: {
    path: globalWebpacklConfig.jsDistPath,
    filename: 'bundle.js'
  },
  module : {
    loaders : [
      {
        test : /\.jsx?/,
        loader : 'babel'
      },
      {
        test : /\.less?/,
        loader : 'style-loader!css-loader!less-loader'
      }
    ]
  },
  resolve:{
    extensions:['','.js','.json']
  },
  plugins: [
    new webpack.NoErrorsPlugin()
  ]
};

module.exports = config;