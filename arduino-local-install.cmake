
function(install_arduino_localy version install_folder download_folder)
    if(WIN32)
        set(ArduinoToolchainArchive arduino-${version}-windows.zip)
    elseif(APPLE)
        set(ArduinoToolchainArchive arduino-${version}-macosx.zip)
    else()
        execute_process(
            COMMAND uname -m
            OUTPUT_VARIABLE linuxarch
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        if(linuxarch MATCHES "arm*")
            set(ArduinoToolchainArchive arduino-${version}-linuxarm.tar.xz)
        elseif(linuxarch STREQUAL "x86_64")
            set(ArduinoToolchainArchive arduino-${version}-linux64.tar.xz)
        else()
            set(ArduinoToolchainArchive arduino-${version}-linux32.tar.xz)
        endif()
    endif()
    if(NOT EXISTS ${download_folder}/${ArduinoToolchainArchive})
        message("Downloading ${ArduinoToolchainArchive}")
        file(DOWNLOAD
            https://downloads.arduino.cc/${ArduinoToolchainArchive}
            ${download_folder}/${ArduinoToolchainArchive}
            SHOW_PROGRESS
            STATUS download_status
        )
        list(GET download_status 0 download_errcode)
        if(download_errcode EQUAL 0)
            message("Download successful")
        else()
            file(REMOVE ${download_folder}/${ArduinoToolchainArchive})
            list(GET download_status 1 download_errmsg)
            message("Download failed: ${download_errmsg} ${download_errcode}")
        endif()
    endif()
    execute_process(
        COMMAND cmake -E tar -xf "${download_folder}/${ArduinoToolchainArchive}"
        WORKING_DIRECTORY ${install_folder}
    )
endfunction()

