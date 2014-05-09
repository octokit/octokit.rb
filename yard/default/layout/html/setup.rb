def diskfile
  @file.attributes[:markup] ||= markup_for_file('', @file.filename)
  data = htmlify(@file.contents, @file.attributes[:markup])

  # Hack our way to working hash anchors for the README.
  # GitHub generates header links as #some-thing and YARD
  # generates them as #Some_thing so this makes the necessary
  # changes to the generate docs so the links work both on
  # GitHub and in the documentation.
  if @file.name == "README"
    bad_link = data.match(/href\=\"\#(.+)\"/)[1]
    data.gsub!(bad_link, bad_link.capitalize.gsub!('-', '_'))
  end

  "<div id='filecontents'>" + data + "</div>"
end
