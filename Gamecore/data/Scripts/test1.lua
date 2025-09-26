function Cutscene()
    ShowDialog("Hello there!")
    coroutine.yield("WAIT_DIALOG")  -- stop here

    ShowDialog("It’s dangerous to go alone!")
    coroutine.yield("WAIT_DIALOG")  -- stop again

    GiveItem("Sword")
    coroutine.yield("DONE")         -- finish
end