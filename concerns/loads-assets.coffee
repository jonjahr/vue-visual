###
Logic related to loading assets
###
export default

	props:

		# Loading
		lazyload: Boolean
		autoload: 
			type: Boolean
			default: true
		transition: 
			type: String
			default: 'vv-fade'

	data: -> 
		shouldLoad: @autoload
		imageLoaded: false
		videoLoaded: false

	computed:

		# Determine whether all assets have been loaded
		allLoaded: ->
			return false if @image and not @imageLoaded
			return false if @video and not @videoLoaded
			return true
		
		# Container classes
		loadsAssetsContainerClasses: ->
			'vv-image-loaded': @imageLoaded
			'vv-video-loaded': @videoLoaded
			'vv-loaded': @allLoaded

	watch:

		# If the asset srcs change, reset the loading state
		image: -> @imageLoaded = false
		video: -> @videoLoaded = false

		# Trigger side effects of assets loading
		imageLoaded: (loaded) -> 
			if loaded
				@applyObjectFitPolyfill 'image' 
				@$emit 'loaded:image'
		videoLoaded: (loaded) -> 
			if loaded
				@applyObjectFitPolyfill 'video' 
				@$emit 'loaded:video'
		allLoaded: (loaded) -> 
			if loaded
				@$emit 'loaded'

	methods:

		# Handle an asset being loaded
		onAssetLoad: (assetType) -> @["#{assetType}Loaded"] = true

		# Manually start loading
		load: -> @shouldLoad = true
