'use strict';
module.exports = function (grunt) {
    require('load-grunt-tasks')(grunt);

    var globalConfig = {
        distPath:       '../../../tpl/hi1626/v2',
        cssSrcPath:     'source/less',
        jsSrcPath:      'source/coffee',
        jadeSrcPath:    'source/jade',
        cssDistPath:    '<%= globalConfig.distPath %>/css',
        jsDebugPath:    '<%= globalConfig.distPath %>/js/login/debug',
        jsDistPath:     '<%= globalConfig.distPath %>/js/login',
        htmlDistPath:   '<%= globalConfig.distPath %>/pages/login',
        cssName:        'login-register'
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

        cssmin: {
            target: {
                files: {
                    '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.css': [
                        '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.css'
                    ]
                }
            }
        },

        less: {
            dist: {
                files: {
                    '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.css': [
                        '<%= globalConfig.cssSrcPath %>/app.less'
                    ]
                    //'assets/css/dist/ie.css':[
                    //    'assets/css/src/if-ie.less'
                    //]
                },
                options: {
                    compress: false,
                    sourceMap: false
                    //sourceMapFilename: '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.css.map',
                    //sourceMapURL: '<%= globalConfig.cssName %>.css.map'
                }
            }
        },

        autoprefixer: {
            dist: {
                files: {
                    '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.css': [
                        '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.css'
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
                    '<%= globalConfig.jsDebugPath %>/login-register.js':[
                        '<%= globalConfig.jsSrcPath %>/util.coffee',
                        '<%= globalConfig.jsSrcPath %>/pick-interest.coffee',
                        '<%= globalConfig.jsSrcPath %>/follow-btn.coffee',
                        '<%= globalConfig.jsSrcPath %>/login-register.coffee'
                    ],
                    '<%= globalConfig.jsDebugPath %>/forget-password.js':[
                        '<%= globalConfig.jsSrcPath %>/util.coffee',
                        '<%= globalConfig.jsSrcPath %>/forget-password.coffee'
                    ],
                    '<%= globalConfig.jsDebugPath %>/social-bind.js':[
                        '<%= globalConfig.jsSrcPath %>/util.coffee',
                        '<%= globalConfig.jsSrcPath %>/social-bind.coffee'
                    ],
                    '<%= globalConfig.jsDebugPath %>/reset-password.js':[
                        '<%= globalConfig.jsSrcPath %>/util.coffee',
                        '<%= globalConfig.jsSrcPath %>/reset-password.coffee'
                    ],
                    '<%= globalConfig.jsDebugPath %>/login-register-ie.js':[
                        '<%= globalConfig.jsSrcPath %>/ie.coffee'
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
    grunt.registerTask('dev', [
        'watch'
    ]);
};