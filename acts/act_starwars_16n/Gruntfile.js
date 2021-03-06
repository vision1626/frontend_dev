'use strict';
module.exports = function (grunt) {
    require('load-grunt-tasks')(grunt);

    var globalConfig = {
        src: 'src',
        dest: 'dev',
        actName:'starwars',
        cssSrcPath: 'source/less',
        jsSrcPath: 'source/coffee',
        jadeSrcPath: 'source/jade',
        cssDistPath: '../../tpl/hi1626/css/<%= globalConfig.actName %>',
        jsDebugPath: '../../tpl/hi1626/js/<%= globalConfig.actName %>/debug',
        jsDistPath: '../../tpl/hi1626/js/<%= globalConfig.actName %>',
        htmlDistPath: '../../tpl/hi1626/page/<%= globalConfig.actName %>',
        cssName: '<%= globalConfig.actName %>',
        jsName: '<%= globalConfig.actName %>',
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
                        '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.css'
                    ]
                }
            }
        },

        less: {
            dist: {
                files: {
                    '<%= globalConfig.cssDistPath %>/<%= globalConfig.cssName %>.css': [
                        '<%= globalConfig.cssSrcPath %>/starwars.less'
                    ]
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
                    '<%= globalConfig.jsDebugPath %>/<%= globalConfig.jsName %>.js':[
                        '<%= globalConfig.jsSrcPath %>/util.coffee',
                        '<%= globalConfig.jsSrcPath %>/starwars.coffee',
                        '<%= globalConfig.jsSrcPath %>/questions.coffee',
                        '<%= globalConfig.jsSrcPath %>/rewards.coffee'
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