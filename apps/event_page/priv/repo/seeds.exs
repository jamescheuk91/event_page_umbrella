# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     EventPage.Repo.insert!(%EventPage.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias EventPage.Repo
alias EventPage.PageContents.Event

event_seeds = [
  %Event{
    name: "RISE | HONG KONG 2017 |",
    description: "RISE is produced by the team behind Web Summit.
    In 6 short years, Web Summit has become Europe's largest tech conference which last year attracted 53,000 ..."
  }
]

event_seeds |> Enum.each(&Repo.insert!(&1))
