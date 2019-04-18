alias Meadow.Data.Repo
alias Meadow.Data.{Collection, File, Image}

Repo.insert!(%Collection{
  title: "Collection One",
  description: "blah blah blah",
  images: [
    %Image{
      title: "Great Image",
      keyword: ["great", "image"],
      files: [
        %File{
          original_filename: "So_What.txt",
          location: "https://library.northwestern.edu/1"
        },
        %File{
          original_filename: "So_What_Again.txt",
          location: "https://library.northwestern.edu/2"
        },
        %File{
          original_filename: "So_What_AGAIN.txt",
          location: "https://library.northwestern.edu/3"
        }
      ]
    },
    %Image{
      title: "Bad Image",
      keyword: ["bad", "image"],
      files: [
        %File{
          original_filename: "So_What_now.txt",
          location: "https://library.northwestern.edu/4"
        },
        %File{
          original_filename: "So_What_Again_please.txt",
          location: "https://library.northwestern.edu/5"
        }
      ]
    }
  ]
})

IO.puts("")
IO.puts("Success! Sample data has been added.")
