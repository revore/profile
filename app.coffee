logDebug = true

Profile = Backbone.Model.extend
  defaults:
    name: 'Full Name'
    tagline: 'A short description of what I do.'

ProfilesCollection = Backbone.Collection.extend
  model: Profile
  url: '/api/profiles'
  # localStorage: new Store('profiles')

profiles = new ProfilesCollection()
theProfile = null

selectors = {}
$("*[data-profile='true']").each (_, val) ->
  console.log "val", val if logDebug
  $val = $(val)
  $val.attr('contenteditable', true)
  selectors[$val.data('profile-name')] = $val

createDefaultProfile = ->
  console.log "len", profiles.length if logDebug
  if profiles.length > 0
    console.log "found profile" if logDebug
    theProfile = profiles.at(0)
    _.each selectors, (val, key) ->
      val.html(theProfile.get(key))
      debouncedSave()
  else
    console.log "create profile" if logDebug
    theProfile = profiles.create()
    _.each selectors, (val, key) ->
      val.html(val, theProfile.set(key))

saveText = ->
  console.log "save text", $name.html(), $tagline.html() if logDebug
  _.each selectors, (val, key) ->
    theProfile.set key, val.html()
    theProfile.save()

debouncedSave = _.throttle(_.debounce(saveText, 100), 300)
$("*[data-profile='true']").keyup debouncedSave

profilesFetch = profiles.fetch()
profilesFetch.done createDefaultProfile
