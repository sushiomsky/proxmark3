#!/usr/bin/env -S pm3 -l

--[[
Script to perform a HF 14a sniff and save the trace data.
--]]

-- Function to perform hf 14a sniff and save trace
function hf_14a_sniff_save()
    -- Start sniffing
    print("Starting HF 14a sniffing...")
    local start_sniff = io.popen("hf 14a sniff")
    local sniff_output = ""

    -- Function to check sniff output for the trace length indication
    local function check_sniff_output()
        while true do
            local output_line = start_sniff:read("*line")
            if output_line then
                print(output_line)
                sniff_output = sniff_output .. output_line .. "\n"
                if string.find(output_line, "%[#%] trace len =") then
                    return true
                end
            else
                return false
            end
        end
    end

    -- Wait until the trace length indication is found
    if check_sniff_output() then
        -- Stop sniffing
        print("Trace length found. Stopping HF 14a sniffing...")
        local stop_sniff = io.popen("hf 14a sniff stop")
        local stop_sniff_output = stop_sniff:read("*all")
        stop_sniff:close()
        
        -- Save trace to a file
        print("Saving trace data to hf14a_sniff_trace.bin...")
        local save_trace = io.popen("data save hf14a_sniff_trace.bin")
        local save_trace_output = save_trace:read("*all")
        save_trace:close()
        
        print("Trace saved successfully.")
    else
        print("Sniffing process ended without detecting the trace length.")
    end
end

print("This script will perform HF 14a sniff and save the trace.\nType 'sniff' to start the operation or 'exit' to exit.\n")
local answer
repeat
    io.write("$>")
    io.flush()
    answer = io.read()
    if answer == 'sniff' then
        hf_14a_sniff_save()
    elseif answer ~= 'exit' then
        print("Unknown command. Type 'sniff' to start the operation or 'exit' to exit.")
    end
until answer == "exit"
print("Bye\n")
