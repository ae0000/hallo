((jQuery) ->
    z = null
    if @VIE isnt undefined
      z = new VIE
      z.use new z.StanbolService
          proxyDisabled: true
          url : 'http://dev.iks-project.eu:8081',

    jQuery.widget 'IKS.halloannotate',
        options:
            vie: z
            editable: null
            toolbar: null
            uuid: ''
            select: ->
            decline: ->
            remove: ->
            buttonCssClass: null

        _create: ->
          widget = @
          if @options.vie is undefined
            throw 'The halloannotate plugin requires VIE to be loaded'
            return

          unless typeof @element.annotate is 'function'
            throw 'The halloannotate plugin requires annotate.js to be loaded'
            return

          # states are off, working, on
          @state = 'off'

          buttonHolder = jQuery "<span class=\"#{widget.widgetName}\"></span>"
          @button = buttonHolder.hallobutton
            label: 'Annotate'
            icon: 'icon-tags'
            editable: @options.editable
            command: null
            uuid: @options.uuid
            cssClass: @options.buttonCssClass
            queryState: false
 
          buttonHolder.bind 'change', (event) =>
            switch @state
              when 'off' then @enhance()
              when 'on' then @done()

          buttonHolder.buttonset()

          @options.toolbar.append @button
          @instantiate()

        instantiate: ->
            @options.editable.element.annotate
                vie: @options.vie
                debug: false
                showTooltip: true
                select: @options.select
                remove: @options.remove
                success: @options.success
                error: @options.error
            # @buttons.acceptAll.hide()
        enhance: ->
            widget = @
            @button.hallobutton "disable"
            try
                @options.editable.element.annotate 'enable', (success) =>
                    if success
                        @state = "on"
                        @button.hallobutton "enable"
                    else
                        @buttons.enhance.show()
                        .button('enable')
                        .button 'option', 'label', 'error, see the log.. Try to enhance again!'
            catch e
                alert e
        done: ->
            @options.editable.element.annotate 'disable'
            @state = 'off'
)(jQuery)
