desc "This task is called by the Heroku scheduler add-on"
task fetch_thumbnails: :environment do
    puts "Fetching thumbnails..."
    AudioVisual.fetch_thumbnails
    puts "done."
end
