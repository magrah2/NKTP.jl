module NKTP

#=
Imports NKT Photonics DLL to use for accessing equipment.
This file is taken as is from NKT with very minor updates 
=#

    using Libdl
    
    # Determine DLL path based on architecture
    const dllFolder = dirname(@__FILE__)
    arch = Sys.iswindows() && Sys.ARCH == :x86_64 ? "x64" : "x86"
    const dllPath = joinpath(dllFolder, "NKTPDLL", arch, "NKTPDLL.dll")
    NKTPDLL = dlopen(dllPath)


    function PortResultTypes(result)
        resultsDict = Dict(
            0 => "0:OPSuccess",
            1 => "1:OPFailed",
            2 => "2:OPPortNotFound",
            3 => "3:OPNoDevices",
            4 => "4:OPApplicationBusy"
        )
        return get(resultsDict, result, "Unknown result")
    end


    function P2PPortResultTypes(result)
        resultsDict = Dict(
            0 => "0:P2PSuccess",
            1 => "1:P2PInvalidPortname",
            2 => "2:P2PInvalidLocalIP",
            3 => "3:P2PInvalidRemoteIP",
            4 => "4:P2PPortnameNotFound",
            5 => "5:P2PPortnameExists",
            6 => "6:P2PApplicationBusy"
        )
        return get(resultsDict, result, "Unknown result")
    end


    function DeviceResultTypes(result)
        resultsDict = Dict(
            0 => "0:DevResultSuccess",
            1 => "1:DevResultWaitTimeout",
            2 => "2:DevResultFailed",
            3 => "3:DevResultDeviceNotFound",
            4 => "4:DevResultPortNotFound",
            5 => "5:DevResultPortOpenError",
            6 => "6:DevResultApplicationBusy"
        )
        return get(resultsDict, result, "Unknown result")
    end


    function DeviceModeTypes(mode)
        resultsDict = Dict(
            0 => "0:DevModeDisabled",
            1 => "1:DevModeAnalyzeInit",
            2 => "2:DevModeAnalyze",
            3 => "3:DevModeNormal",
            4 => "4:DevModeLogDownload",
            5 => "5:DevModeError",
            6 => "6:DevModeTimeout",
            7 => "7:DevModeUpload"
        )
        return get(resultsDict, mode, "Unknown mode "*string(mode))
    end


    function RegisterResultTypes(result)
        resultsDict = Dict(
            0 => "0:RegResultSuccess",
            1 => "1:RegResultReadError",
            2 => "2:RegResultFailed",
            3 => "3:RegResultBusy",
            4 => "4:RegResultNacked",
            5 => "5:RegResultCRCErr",
            6 => "6:RegResultTimeout",
            7 => "7:RegResultComError",
            8 => "8:RegResultTypeError",
            9 => "9:RegResultIndexError",
            10 => "10:RegResultPortClosed",
            11 => "11:RegResultRegisterNotFound",
            12 => "12:RegResultDeviceNotFound",
            13 => "13:RegResultPortNotFound",
            14 => "14:RegResultPortOpenError",
            15 => "15:RegResultApplicationBusy"
        )
        return get(resultsDict, result, "Unknown result")
    end


    function registerDataTypes(datatype)
        dataTypesDict = Dict(
            0 => "0:RegData_Unknown",
            1 => "1:RegData_Array",
            2 => "2:RegData_U8",
            3 => "3:RegData_S8",
            4 => "4:RegData_U16",
            5 => "5:RegData_S16",
            6 => "6:RegData_U32",
            7 => "7:RegData_S32",
            8 => "8:RegData_F32",
            9 => "9:RegData_U64",
            10 => "10:RegData_S64",
            11 => "11:RegData_F64",
            12 => "12:RegData_Ascii",
            13 => "13:RegData_Paramset",
            14 => "14:RegData_B8",
            15 => "15:RegData_H8",
            16 => "16:RegData_B16",
            17 => "17:RegData_H16",
            18 => "18:RegData_B32",
            19 => "19:RegData_H32",
            20 => "20:RegData_B64",
            21 => "21:RegData_H64",
            22 => "22:RegData_DateTime"
        )

        return get(dataTypesDict, datatype, "Unknown data type")
    end


    function RegisterPriorityTypes(priority)
        resultsDict = Dict(
            0 => "0:RegPriority_Low",
            1 => "1:RegPriority_High"
        )
        return get(resultsDict, priority, "Unknown priority")
    end


    function PortStatusTypes(status)
        resultsDict = Dict(
            0 => "0:PortStatusUnknown",
            1 => "1:PortOpening",
            2 => "2:PortOpened",
            3 => "3:PortOpenFail",
            4 => "4:PortScanStarted",
            5 => "5:PortScanProgress",
            6 => "6:PortScanDeviceFound",
            7 => "7:PortScanEnded",
            8 => "8:PortClosing",
            9 => "9:PortClosed",
            10 => "10:PortReady"
        )
        return get(resultsDict, status, "Unknown status")
    end


    function DeviceStatusTypes(status)
        resultsDict = Dict(
            0 => "0:DeviceModeChanged",
            1 => "1:DeviceLiveChanged",
            2 => "2:DeviceTypeChanged",
            3 => "3:DevicePartNumberChanged",
            4 => "4:DevicePCBVersionChanged",
            5 => "5:DeviceStatusBitsChanged",
            6 => "6:DeviceErrorCodeChanged",
            7 => "7:DeviceBlVerChanged",
            8 => "8:DeviceFwVerChanged",
            9 => "9:DeviceModuleSerialChanged",
            10 => "10:DevicePCBSerialChanged",
            11 => "11:DeviceSysTypeChanged"
        )
        return get(resultsDict, status, "Unknown status")
    end


    function RegisterStatusTypes(status)
        resultsDict = Dict(
            0 => "0:RegSuccess",
            1 => "1:RegBusy",
            2 => "2:RegNacked",
            3 => "3:RegCRCErr",
            4 => "4:RegTimeout",
            5 => "5:RegComError"
        )
        return get(resultsDict, status, "Unknown status")
    end


    struct TDateTimeStruct
        Sec::UInt8   # Seconds
        Min::UInt8   # Minutes
        Hour::UInt8  # Hours
        Day::UInt8   # Days
        Month::UInt8 # Months
        Year::UInt8  # Years
    end

    function ParamSetUnitTypes(unit)
        unitTypesDict = Dict(
            0 => "0:Unit None",
            1 => "1:Unit mV",
            2 => "2:Unit V",
            3 => "3:Unit uA",
            4 => "4:Unit mA",
            5 => "5:Unit A",
            6 => "6:Unit uW",
            7 => "7:Unit cmW",
            8 => "8:Unit dmW",
            9 => "9:Unit mW",
            10 => "10:Unit W",
            11 => "11:Unit mC",
            12 => "12:Unit cC",
            13 => "13:Unit dC",
            14 => "14:Unit pm",
            15 => "15:Unit dnm",
            16 => "16:Unit nm",
            17 => "17:Unit PerCent",
            18 => "18:Unit PerMille",
            19 => "19:Unit cmA",
            20 => "20:Unit dmA",
            21 => "21:Unit RPM",
            22 => "22:Unit dBm",
            23 => "23:Unit cBm",
            24 => "24:Unit mBm",
            25 => "25:Unit dB",
            26 => "26:Unit cB",
            27 => "27:Unit mB",
            28 => "28:Unit dpm",
            29 => "29:Unit cV",
            30 => "30:Unit dV",
            31 => "31:Unit lm",
            32 => "32:Unit dlm",
            33 => "33:Unit clm",
            34 => "34:Unit mlm"
        )

        return get(unitTypesDict, unit, "Unknown unit")
    end


    struct TParamSetStruct
        Unit::UInt8          # Unit type as defined in ::ParamSetUnitTypes
        ErrorHandler::UInt8  # Warning/Error handler not used.
        StartVal::UInt16     # Setpoint for Settings parameterset, unused in Measurement parametersets.
        FactoryVal::UInt16   # Factory Setpoint for Settings parameterset, unused in Measurement parametersets.
        ULimit::UInt16       # Upper limit.
        LLimit::UInt16       # Lower limit.
        Numerator::Int16     # Numerator (X) for calculation.
        Denominator::Int16   # Denominator (Y) for calculation.
        Offset::Int16        # Offset for calculation.
    end


    function getAllPorts()
        maxLen = UInt16(255) # Initial length of the buffer
        portnames = Vector{Cchar}(undef, maxLen[]) # Allocate buffer for port names
        # Call the function
        ccall((:getAllPorts, dllPath), Cvoid, (Ref{Cchar}, Ref{UInt16}), portnames, maxLen)
        portname_str = String(UInt8.(portnames[1:(findfirst(==(0), portnames)-1)]))
        # Convert Cchar array to String
        return portname_str
    end

    function getOpenPorts()
        maxLen = UInt16(255) # Initial length of the buffer
        portnames = Vector{Cchar}(undef, maxLen[]) # Allocate buffer for port names
        # Call the function
        ccall((:getOpenPorts, dllPath), Cvoid, (Ref{Cchar}, Ref{UInt16}), portnames, maxLen)
        portname_str = String(UInt8.(portnames[1:(findfirst(==(0), portnames)-1)]))
        # Convert Cchar array to String
        return portname_str
    end



    function openPorts(portnames::String, autoMode::Int, liveMode::Int)
        # Convert the Julia string to a C-compatible string
        #c_portnames = Cstring(pointer(portnames))

        # Call the C function
        result = ccall((:openPorts, dllPath), Cuchar, (Cstring, Cuchar, Cuchar), portnames, autoMode, liveMode)
        return result
    end


    function closePorts(portnames::String)
        #c_portnames = Cstring(pointer(portnames))
        result = ccall((:closePorts, dllPath), Cuchar, (Cstring,), portnames)
        return result
    end

    #-------------- READ FUNCTIONS -----------------------


    function registerRead(portname::String, devId::Int, regId::UInt8, index::Int)
        maxLen = UInt8(255)
        readData = Vector{Cchar}(undef, maxLen)
        result = ccall((:registerRead, dllPath), UInt8, 
                    (Cstring, UInt8, UInt8, Ref{Cchar}, Ref{UInt8}, Int16), 
                    portname, devId, regId, readData, Ref(maxLen), index)
        if result != 0
            maxLen = UInt8(0)
        end
        return result, readData[1:maxLen]
    end


    function registerReadU8(portname::String, devId::UInt8, regId::UInt8, index::Int)
        index = Int16(index)
        readValue = Ref{Cuchar}(0)
        result = ccall((:registerReadU8, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Ref{Cuchar}, Cshort), 
                    portname, devId, regId, readValue, index)
        return result, Int(readValue[])
    end

    function registerReadS8(portname::String, devId::UInt8, regId::UInt8, index::Int)
        index = Int16(index)
        readValue = Ref{Cchar}(0)
        result = ccall((:registerReadS8, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Ref{Cchar}, Cshort), 
                    portname, devId, regId, readValue, index)
        return result, Int(readValue[])
    end

    function registerReadU16(portname::String, devId::UInt8, regId::UInt8, index::Int)
        index = Int16(index)
        readValue = Ref{Cushort}(0)
        result = ccall((:registerReadU16, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Ref{Cushort}, Cshort), 
                    portname, devId, regId, readValue, index)
        return result, Int(readValue[])
    end



    function registerReadS16(portname::String, devId::UInt8, regId::UInt8, index::Int)
        index = Int16(index)
        readValue = Ref{Cshort}(0)
        result = ccall((:registerReadS16, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Ref{Cshort}, Cshort), 
                    portname, devId, regId, readValue, index)
        return result, Int(readValue[])
    end


    function registerReadU32(portname::String, devId::UInt8, regId::UInt8, index::Int)
        index = Int16(index)
        readValue = Ref{Cuint}(0)
        result = ccall((:registerReadU32, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Ref{Cuint}, Cshort), 
                    portname, devId, regId, readValue, index)
        return result, Int(readValue[])
    end


    function registerReadS32(portname::String, devId::UInt8, regId::UInt8, index::Int)
        index = Int16(index)
        readValue = Ref{Cint}(0)
        result = ccall((:registerReadS32, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Ref{Cint}, Cshort), 
                    portname, devId, regId, readValue, index)
        return result, Int(readValue[])
    end


    function registerReadU64(portname::String, devId::UInt8, regId::UInt8, index::Int)
        index = Int16(index)
        readValue = Ref{Culonglong}(0)
        result = ccall((:registerReadU64, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Ref{Culonglong}, Cshort), 
                    portname, devId, regId, readValue, index)
        return result, Int(readValue[])
    end



    function registerReadS64(portname::String, devId::UInt8, regId::UInt8, index::Int)
        index = Int16(index)
        readValue = Ref{Clonglong}(0)
        result = ccall((:registerReadS64, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Ref{Clonglong}, Cshort), 
                    portname, devId, regId, readValue, index)
        return result, Int(readValue[])
    end



    function registerReadF32(portname::String, devId::UInt8, regId::UInt8, index::Int)
        index = Int16(index)
        readValue = Ref{Cfloat}(0)
        result = ccall((:registerReadF32, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Ref{Cfloat}, Cshort), 
                    portname, devId, regId, readValue, index)
        return result, Int(readValue[])
    end


    function registerReadF64(portname::String, devId::UInt8, regId::UInt8, index::Int)
        index = Int16(index)
        readValue = Ref{Cdouble}(0)
        result = ccall((:registerReadF64, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Ref{Cdouble}, Cshort), 
                    portname, devId, regId, readValue, index)
        return result, Int(readValue[])
    end


    function registerReadAscii(portname::String, devId::UInt8, regId::UInt8, index::Int)
        index = Int16(index)
        readValue = Ref{Cchar}(0)
        result = ccall((:registerReadAscii, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Ref{Cchar}, Cshort), 
                    portname, devId, regId, readValue, index)
        return result, Int(readValue[])
    end


    #------------------- WRITE FUNCTIONS --------------------------

    function registerWrite(portname::String, devId::UInt8, regId::UInt8, index::Int)
        maxLen = UInt8(255)
        readData = Vector{Cchar}(undef, maxLen)
        result = ccall((:registerWrite, dllPath), UInt8, 
                    (Cstring, UInt8, UInt8, Ref{Cchar}, Ref{UInt8}, Int16), 
                    portname, devId, regId, readData, Ref(maxLen), index)
        if result != 0
            maxLen = UInt8(0)
        end
        return result, readData[1:maxLen]
    end


    function registerWriteU8(portname::String, devId::UInt8, regId::UInt8, writeValue::UInt8, index::Int)
        index = Int16(index)
        return ccall((:registerWriteU8, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Cuchar, Cshort), 
                    portname, devId, regId, writeValue, index)
    end


    function registerWriteS8(portname::String, devId::UInt8, regId::UInt8, writeValue::Int8, index::Int)
        index = Int16(index)
        return ccall((:registerWriteS8, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Cchar, Cshort), 
                    portname, devId, regId, writeValue, index)
    end


    function registerWriteU16(portname::String, devId::UInt8, regId::UInt8, writeValue::UInt16, index::Int)
        index = Int16(index)
        return ccall((:registerWriteU16, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Cushort, Cshort), 
                    portname, devId, regId, writeValue, index)
    end


    function registerWriteS16(portname::String, devId::UInt8, regId::UInt8, writeValue::Int16, index::Int)
        index = Int16(index)
        return ccall((:registerWriteS16, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Cshort, Cshort), 
                    portname, devId, regId, writeValue, index)
    end


    function registerWriteU32(portname::String, devId::UInt8, regId::UInt8, writeValue::UInt32, index::Int)
        index = Int16(index)
        return ccall((:registerWriteU32, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Cuint, Cshort), 
                    portname, devId, regId, writeValue, index)
    end

    function registerWriteS32(portname::String, devId::UInt8, regId::UInt8, writeValue::Int32, index::Int)
        index = Int16(index)
        return ccall((:registerWriteS32, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Cint, Cshort), 
                    portname, devId, regId, writeValue, index)
    end


    function registerWriteU64(portname::String, devId::UInt8, regId::UInt8, writeValue::UInt64, index::Int)
        index = Int16(index)
        return ccall((:registerWriteU64, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Culonglong, Cshort), 
                    portname, devId, regId, writeValue, index)
    end


    function registerWriteS64(portname::String, devId::UInt8, regId::UInt8, writeValue::Int64, index::Int)
        index = Int16(index)
        return ccall((:registerWriteU64, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Clonglong, Cshort), 
                    portname, devId, regId, writeValue, index)
    end


    function registerWriteF32(portname::String, devId::UInt8, regId::UInt8, writeValue::Float32, index::Int)
        index = Int16(index)
        return ccall((:registerWriteF32, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Cfloat, Cshort), 
                    portname, devId, regId, writeValue, index)
    end

    function registerWriteF64(portname::String, devId::UInt8, regId::UInt8, writeValue::Float64, index::Int)
        index = Int16(index)
        return ccall((:registerWriteF64, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Cdouble, Cshort), 
                    portname, devId, regId, writeValue, index)
    end


    function registerWriteAscii(portname::String, devId::UInt8, regId::UInt8, writeString::String, writeEOL::Int8, index::Int)
        index = Int16(index)
        return ccall((:registerWriteF64, dllPath), Cuchar, 
                    (Cstring, Cuchar, Cuchar, Cstring, Cchar, Cshort), 
                    portname, devId, regId, writeString, writeEOL, index)
    end


end
