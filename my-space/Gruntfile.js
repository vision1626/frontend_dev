'use strict';
module.exports = function (grunt) {
    require('load-grunt-tasks')(grunt);

    var globalConfig = {
        distPath:       '../../tpl/hi1626/v2',
        cssSrcPath:     'source/less',
        jsSrcPath:      'source/coffee',
        jadeSrcPath:    'source/jade',
        cssDistPath:    '<%= globalConfig.distPath %>/css/',
        jsDebugPath:    '<%= globalConfig.distPath %>/js/debug',
        jsDistPath:     '<%= globalConfig.distPath %>/js/',
        htmlDistPath:   '<%= globalConfig.distPath %>/views/myspace',
        viewName:       'myspace',
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
            jade:{
                files: ['<%= globalConfig.jadeSrcPath %>/*.jade'],
                tasks: ['jade4php']
            }
        },

        //cssmin: {
        //    target: {
        //        files: {
        //            '<%= globalConfig.cssDistPath %>/<%= globalConfig.viewName %>.min.css': [
        //                '<%= globalConfig.cssDistPath %>/<%= globalConfig.viewName %>.min.css'
        //            ]
        //        }
        //    }
        //},

        cssmin: {
            target: {
                files: [{
                    expand: true,
                    cwd: '<%= globalConfig.cssDistPath %>',
                    src: '**/*.css',
                    dest: '<%= globalConfig.cssDistPath %>'
                }]
            }
        },

        //less: {
        //    dist: {
        //        files: {
        //            '<%= globalConfig.cssDistPath %>/<%= globalConfig.viewName %>.min.css': [
        //                '<%= globalConfig.cssSrcPath %>/app.less'
        //            ]
        //            //'assets/css/dist/ie.css':[
        //            //    'assets/css/src/if-ie.less'
        //            //]
        //        },
        //        options: {
        //            compress: false,
        //            sourceMap: true,
        //            sourceMapFilename: '<%= globalConfig.cssDistPath %>/<%= globalConfig.viewName %>.min.css.map',
        //            sourceMapURL: '<%= globalConfig.viewName %>.min.css.map'
        //        }
        //    }
        //},

        less: {
            target: {
                files: {
                    '<%= globalConfig.cssDistPath %>/<%= globalConfig.viewName %>.css': '<%= globalConfig.cssSrcPath %>/**/*.less'
                }
            }
            //src: {
            //    expand: true,
            //    cwd: '<%= globalConfig.cssSrcPath %>',
            //    src: '**/*.less',
            //    dest: '<%= globalConfig.cssDistPath %>'
            //}
        },

        //autoprefixer: {
        //    dist: {
        //        files: {
        //            '<%= globalConfig.cssDistPath %>/<%= globalConfig.viewName %>.min.css': [
        //                '<%= globalConfig.cssDistPath %>/<%= globalConfig.viewName %>.min.css'
        //            ]
        //        }
        //    }
        //},
        autoprefixer: {
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= globalConfig.cssDistPath %>',
                    src: '**/*.css',
                    dest: '<%= globalConfig.cssDistPath %>'
                }]
            }
        },

        coffee: {
            options: {
                sourceMap: true,
                bare: true
            },
            compile: {
                files: {
                    '<%= globalConfig.jsDebugPath %>/myspace.js':[
                        // '<%= globalConfig.jsSrcPath %>/util.coffee',
                        '<%= globalConfig.jsSrcPath %>/header.coffee'
                    ],
                    '<%= globalConfig.jsDebugPath %>/dashboard.js':[
                        '<%= globalConfig.jsSrcPath %>/util.coffee',
                        '<%= globalConfig.jsSrcPath %>/dashboard.coffee'
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
                    cwd: '<%= globalConfig.jsDebugPath %>',
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
                files:[{
                    expand: true,
                    cwd: '<%= globalConfig.jadeSrcPath %>/',
                    src: ['*.jade'],
                    dest: '<%= globalConfig.htmlDistPath %>/',
                    ext: '.htm'
                }]
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
    grunt.registerTask('dev', [
        'watch'
    ]);
};