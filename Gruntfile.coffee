module.exports = (grunt) ->

    grunt.initConfig
        watch:
            livereload:
                options:
                    livereload: true
                files: [
                    'index.html'
                    'js/*.js'
                    'scss/*.scss'
                    'css/*.css'
                ]

            coffeelint:
                files: ['Gruntfile.coffee']
                tasks: ['coffeelint']

            buildIndex:
                files: ['partials/*.html']
                tasks: ['buildIndex']

            sass:
                files: ['scss/**/*']
                tasks: ['sass']

            svgstore:
                files: [
                    'svg/*.svg'
                ]
                tasks: ['svgstore']

        svgstore:
            options:
                prefix: 'svg-'
            default:
                files:
                    'partials/_sprite.html': ['svg/*.svg']
        sass:

            dist:
                options:
                    sourcemap: true
                    style: 'compressed'
                files:
                    'css/test.css': 'scss/test.scss'
                    'css/ions.css': 'scss/ions.scss'

        connect:

            livereload:
                options:
                    port: 9000
                    hostname: 'localhost'
                    base: '.'
                    open: true
                    livereload: true

        coffeelint:

            options:
                indentation:
                    value: 4

            all: ['Gruntfile.coffee']

        # jshint:

        #     options:
        #         jshintrc: '.jshintrc'

        #     all: ['js/app.js']

        copy:

            dist:
                files: [{
                    expand: true
                    src: [
                        'svgs/**'
                        'bower_components/**'
                        'js/**'
                        'css/*.css'
                    ]
                    dest: 'dist/'
                },{
                    expand: true
                    src: ['index.html']
                    dest: 'dist/'
                    filter: 'isFile'
                }]

    # Load all grunt tasks.
    require('load-grunt-tasks')(grunt)

    grunt.registerTask 'buildIndex',
        'Build index.html from partials/_index.html and partials/_sprite.html.',
        ->
            indexTemplate = grunt.file.read 'partials/_index.html'
            svgSprite = grunt.file.read 'partials/_sprite.html'

            html = grunt.template.process indexTemplate, data:
                svgSprite:
                    svgSprite

            grunt.file.write 'index.html', html

    grunt.registerTask 'svg',
        'create svg sprite', [
            'svgstore'
        ]

    grunt.registerTask 'test',
        '*Lint* javascript and coffee files.', [
            'coffeelint'
            'jshint'
        ]

    grunt.registerTask 'server',
        'Run presentation locally and start watch process (living document).', [
            'sass'
            'svg'
            'buildIndex'
            'connect:livereload'
            'watch'
        ]

    # Define default task.
    grunt.registerTask 'default', [
        'server'
    ]