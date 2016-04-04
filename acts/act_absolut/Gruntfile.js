'use strict';
module.exports = function (grunt) {
  require('load-grunt-tasks')(grunt);

  var globalConfig = {
    moduleName:     'absolut',
    distPath:       '../../../tpl/hi1626',
    cssSrcPath:     'source/less',
    jsSrcPath:      'source/coffee',
    jadeSrcPath:    'source/jade',
    cssDistPath:    '<%= globalConfig.distPath %>/css/act/<%= globalConfig.moduleName %>',
    jsDistPath:     '<%= globalConfig.distPath %>/js/act/<%= globalConfig.moduleName %>',
    htmlDistPath:   '<%= globalConfig.distPath %>/page/<%= globalConfig.moduleName %>'
  };

  grunt.initConfig({
    globalConfig: globalConfig,
    watch: {
      less: {
        files: ['<%= globalConfig.cssSrcPath %>/*.less'],
        tasks: ['less', 'autoprefixer', 'cssmin']
      },
      js: {
        files: ['<%= globalConfig.jsSrcPath %>/*.coffee'],
        tasks: ['coffee', 'uglify']
      },
      jade: {
        files: ['<%= globalConfig.jadeSrcPath %>/**/*.jade'],
        tasks: ['jade4php']
      }
    },

    cssmin: {
      target: {
        files: {
          '<%= globalConfig.cssDistPath %>/<%= globalConfig.moduleName %>.css': [
            '<%= globalConfig.cssDistPath %>/<%= globalConfig.moduleName %>.css'
          ]
        }
      }
    },


    less: {
      dist: {
        files: {
          '<%= globalConfig.cssDistPath %>/<%= globalConfig.moduleName %>.css': [
            '<%= globalConfig.cssSrcPath %>/<%= globalConfig.moduleName %>.less'
          ]
        },
        options: {
          compress: false,
          sourceMap: false
        }
      }
    },

    autoprefixer: {
      dist: {
        files: {
          '<%= globalConfig.cssDistPath %>/<%= globalConfig.moduleName %>.css': [
            '<%= globalConfig.cssDistPath %>/<%= globalConfig.moduleName %>.css'
          ]
        }
      }
    },

    coffee: {
      options: {
        sourceMap: true,
        bare: true
      },
      compile: {
        files: {
          '<%= globalConfig.jsDistPath %>/<%= globalConfig.moduleName %>.js':[
            '<%= globalConfig.jsSrcPath %>/**/*.coffee'
          ]
        }
      }
    },

    uglify: {
      options: {
        beautify: false,
        compress: {
          drop_console: true
        }
      },
      dist: {
        files: [{
          expand: true,
          cwd: '<%= globalConfig.jsDistPath %>',
          src: '**/*.js',
          dest: '<%= globalConfig.jsDistPath %>'
        }]
      }
    },

    jade4php: {
      compile: {
        options: {
          pretty: true,
          basedir: __dirname
        },
        expand: true,
        cwd: '<%= globalConfig.jadeSrcPath %>/',
        src: ['*.jade'],
        dest: '<%= globalConfig.htmlDistPath %>/',
        ext: '.htm'
      }
    }
  });

  // Register tasks
  grunt.registerTask('default', [
    'less',
    'autoprefixer',
    'cssmin',
    'coffee',
    'uglify',
    'jade4php'
  ]);
  grunt.registerTask('css', [
    'less',
    'autoprefixer',
    'cssmin'
  ]);
  grunt.registerTask('dev', [
    'watch'
  ]);
};