logDebug = true

$name = $("#name")
$tagline = $("#tagline")

Profile = Backbone.Model.extend
  defaults:
    name: 'Full Name'
    tagline: 'A short description of what I do.'

ProfilesCollection = Backbone.Collection.extend
  model: Profile
  # url: '/api/profiles.json'
  localStorage: new Store('profiles')

profiles = new ProfilesCollection()
theProfile = null

createDefaultProfile = ->
  console.log "len", profiles.length if logDebug
  if profiles.length > 0
    console.log "found profile" if logDebug
    theProfile = profiles.at(0)
    $("*[data-profile='true']").each (i, val) ->
      console.log "val", val, i if logDebug
      attributeSelector = $(val)
      profileAttributeName = attributeSelector.data('profile-name')
      console.log "set", profileAttributeName, "to", theProfile.get(profileAttributeName) if logDebug
      attributeSelector.html(theProfile.get(profileAttributeName))
  else
    console.log "create profile" if logDebug
    theProfile = profiles.create({})
    $("*[data-profile='true']").each (i, val) ->
      console.log "val", val, i if logDebug
      attributeSelector = $(val)
      theProfile.set attributeSelector, attributeSelector.html()

saveText = ->
  console.log "save text", $name.html(), $tagline.html() if logDebug
  theProfile.set "name", $name.html()
  theProfile.set "tagline", $tagline.html()
  theProfile.save()

debouncedSave = _.throttle(_.debounce(saveText, 100), 300)
$name.keyup debouncedSave
$tagline.keyup debouncedSave

profilesFetch = profiles.fetch()
profilesFetch.done createDefaultProfile
