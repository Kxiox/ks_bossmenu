local display = false

function toggleNui()
    display = not display
    SetNuiFocus(display, display)
    SendNUIMessage({
        action = 'showMessage',
        message = 'UI is now ' .. (display and 'visible' or 'hidden')        
    })
end

RegisterCommand('toggleui', function ()
    toggleNui()
end)

RegisterNUICallback('exampleCallback', function (data, cb)
    print('Message from NUI:', data.message)
    cb('ok')
end)