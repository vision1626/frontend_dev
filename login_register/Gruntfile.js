'use strict';
module.exports = function (grunt) {
    require('load-grunt-tasks')(grunt);

    var globalConfig = {
        src: 'src',
        dest: 'dev',
        cssSrcPath: 'source/less',
        jsSrcPath: 'source/coffee',
        jadeSrcPath: 'source/jade',
        cssDistPath: '../../tpl/hi1626/css/login/dist',
        jsDebugPath: '../../tpl/hi1626/js/login/debug',
        jsDistPath: '../../tpl/hi1626/js/login',
        htmlDistPath: '../../tpl/hi1626/page/user',
        cssName: 'login-register',
        jsName: 'scripts'
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
                    '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.min.css': [
                        '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.min.css'
                    ]
                }
            }
        },

        less: {
            dist: {
                files: {
                    '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.min.css': [
                        '<%= globalConfig.cssSrcPath %>/app.less'
                    ]
                    //'assets/css/dist/ie.css':[
                    //    'assets/css/src/if-ie.less'
                    //]
                },
                options: {
                    compress: false,
                    sourceMap: true,
                    sourceMapFilename: '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.min.css.map',
                    sourceMapURL: '<%= globalConfig.cssName %>.min.css.map'
                }
            }
        },

        autoprefixer: {
            dist: {
                files: {
                    '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.min.css': [
                        '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.min.css'
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
                        '<%= globalConfig.jsSrcPath %>/share-function.coffee',
                        '<%= globalConfig.jsSrcPath %>/login-register.coffee'
                    ],
                    '<%= globalConfig.jsDebugPath %>/forget-password.js':[
                        '<%= globalConfig.jsSrcPath %>/share-function.coffee',
                        '<%= globalConfig.jsSrcPath %>/forget-password.coffee'
                    ],
                    '<%= globalConfig.jsDebugPath %>/social-bind.js':[
                        '<%= globalConfig.jsSrcPath %>/share-function.coffee',
                        '<%= globalConfig.jsSrcPath %>/social-bind.coffee'
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
                    pretty: true
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