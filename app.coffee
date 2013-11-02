logDebug = true

$name = $("#name")

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
    $name.html(theProfile.get("name"))
  else
    console.log "create profile" if logDebug
    theProfile = profiles.create({
      copy: $name.html()
    })

saveText = ->
  console.log "save text", $name.html()
  theProfile.set("name", $name.html())
  theProfile.save()

debouncedSave = _.debounce(saveText, 100)
$name.keyup debouncedSave

profilesFetch = profiles.fetch()
profilesFetch.done createDefaultProfile
