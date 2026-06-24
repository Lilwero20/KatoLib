local Library = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local Theme = {
    BG = Color3.fromRGB(15,10,24),
    SEC = Color3.fromRGB(26,20,35),
    ACC = Color3.fromRGB(138,43,226),
    TXT = Color3.fromRGB(255,255,255),
    SUB = Color3.fromRGB(160,157,171)
}

local function C(c,p)
    local o=Instance.new(c)
    for k,v in pairs(p or {}) do o[k]=v end
    return o
end

local function Corner(o,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r)
    c.Parent=o
end

local function Tween(o,t,p)
    TweenService:Create(o,TweenInfo.new(t,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),p):Play()
end

local function Drag(frame,handle)
    local drag,start,pos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=true; start=i.Position; pos=frame.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then drag=false end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-start
            frame.Position=UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
        end
    end)
end

function Library:CreateWindow(cfg)
    local pg=Players.LocalPlayer:WaitForChild("PlayerGui")

    local gui=C("ScreenGui",{ResetOnSpawn=false,IgnoreGuiInset=true})
    gui.Parent=pg

    local blur=Lighting:FindFirstChild("KatoBlur") or Instance.new("BlurEffect")
    blur.Name="KatoBlur"
    blur.Size=18
    blur.Parent=Lighting

    local main=C("Frame",{
        Parent=gui,
        AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.fromScale(.5,.5),
        Size=UDim2.fromScale(.58,.66),
        BackgroundColor3=Theme.BG
    })
    Corner(main,14)

    local stroke=Instance.new("UIStroke",main)
    stroke.Color=Theme.ACC

    local header=C("Frame",{Parent=main,BackgroundTransparency=1,Size=UDim2.new(1,0,0,80)})

    local title=C("TextLabel",{
        Parent=header,BackgroundTransparency=1,
        Position=UDim2.new(0,20,0,10),Size=UDim2.new(0,400,0,30),
        Text=cfg.Title or "Kato Script",
        Font=Enum.Font.GothamBold,TextSize=22,TextColor3=Theme.TXT,
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local sub=C("TextLabel",{
        Parent=header,BackgroundTransparency=1,
        Position=UDim2.new(0,20,0,38),Size=UDim2.new(0,400,0,20),
        Text=cfg.Subtitle or "+1 Speed Keyboard Escape",
        Font=Enum.Font.Gotham,TextSize=14,TextColor3=Theme.SUB,
        TextXAlignment=Enum.TextXAlignment.Left
    })

    local close=C("TextButton",{
        Parent=header,Text="✕",
        Size=UDim2.fromOffset(40,40),
        Position=UDim2.new(1,-50,0,18),
        BackgroundColor3=Theme.SEC,TextColor3=Theme.TXT
    })
    Corner(close,10)

    local mini=close:Clone()
    mini.Parent=header
    mini.Text="—"
    mini.Position=UDim2.new(1,-100,0,18)

    local sidebar=C("Frame",{
        Parent=main,
        Position=UDim2.new(0,0,0,80),
        Size=UDim2.new(.25,0,1,-80),
        BackgroundColor3=Color3.fromRGB(10,7,18)
    })

    local sideLayout=Instance.new("UIListLayout",sidebar)
    sideLayout.Padding=UDim.new(0,8)

    local content=C("Frame",{
        Parent=main,
        Position=UDim2.new(.25,0,0,80),
        Size=UDim2.new(.75,0,1,-80),
        BackgroundTransparency=1
    })

    Drag(main,header)

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local min=false
    local old=main.Size
    mini.MouseButton1Click:Connect(function()
        min=not min
        Tween(main,.25,{Size=min and UDim2.new(old.X.Scale,0,0,80) or old})
    end)

    local Window={SidebarTabs={}}

    function Window:CreateSidebarTab(name)
        local btn=C("TextButton",{
            Parent=sidebar,
            Size=UDim2.new(1,-10,0,44),
            Text=name,
            BackgroundColor3=Theme.SEC,
            TextColor3=Theme.TXT
        })
        Corner(btn,10)

        local page=C("Frame",{
            Parent=content,
            Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,
            Visible=false
        })

        local topBar=C("Frame",{
            Parent=page,
            Size=UDim2.new(1,0,0,40),
            BackgroundTransparency=1
        })

        local pages={}

        function pages:CreateTopTab(tabName)
            local tabBtn=C("TextButton",{
                Parent=topBar,
                Size=UDim2.fromOffset(180,40),
                Text=tabName,
                BackgroundTransparency=1,
                TextColor3=Theme.TXT
            })

            local container=C("ScrollingFrame",{
                Parent=page,
                Position=UDim2.new(0,0,0,40),
                Size=UDim2.new(1,0,1,-40),
                CanvasSize=UDim2.new(),
                AutomaticCanvasSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,
                Visible=false
            })

            local layout=Instance.new("UIListLayout",container)
            layout.Padding=UDim.new(0,10)

            local tab={}

            function tab:CreateSection(titleText)
                local sec=C("Frame",{
                    Parent=container,
                    Size=UDim2.new(1,-20,0,220),
                    BackgroundColor3=Theme.SEC
                })
                Corner(sec,12)

                local t=C("TextLabel",{
                    Parent=sec,
                    Text=titleText,
                    BackgroundTransparency=1,
                    TextColor3=Theme.TXT,
                    Font=Enum.Font.GothamBold,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    Size=UDim2.new(1,-20,0,30),
                    Position=UDim2.new(0,10,0,10)
                })

                local Section={}

                function Section:AddButton(text,callback)
                    local b=C("TextButton",{
                        Parent=sec,
                        Text=text,
                        Position=UDim2.new(0,10,0,50),
                        Size=UDim2.new(1,-20,0,40),
                        BackgroundColor3=Theme.ACC,
                        TextColor3=Theme.TXT
                    })
                    Corner(b,8)
                    b.MouseButton1Click:Connect(function()
                        if callback then callback() end
                    end)
                end

                function Section:AddToggle(text,default,callback)
                    local state=default
                    local b=C("TextButton",{
                        Parent=sec,
                        Text=text,
                        Position=UDim2.new(0,10,0,100),
                        Size=UDim2.new(0,220,0,36),
                        BackgroundColor3=state and Theme.ACC or Theme.BG,
                        TextColor3=Theme.TXT
                    })
                    Corner(b,18)
                    b.MouseButton1Click:Connect(function()
                        state=not state
                        Tween(b,.2,{BackgroundColor3=state and Theme.ACC or Theme.BG})
                        if callback then callback(state) end
                    end)
                end

                function Section:AddSlider(text,min,max,default,callback)
                    local value=default or min
                    local lbl=C("TextLabel",{
                        Parent=sec,BackgroundTransparency=1,
                        Position=UDim2.new(0,10,0,150),
                        Size=UDim2.new(1,-20,0,20),
                        Text=text..": "..tostring(value),
                        TextColor3=Theme.TXT
                    })
                    if callback then callback(value) end
                end

                return Section
            end

            if not next(pages) then container.Visible=true end
            return tab
        end

        btn.MouseButton1Click:Connect(function()
            for _,v in pairs(Window.SidebarTabs) do
                v.Visible=false
            end
            page.Visible=true
        end)

        table.insert(Window.SidebarTabs,page)
        if #Window.SidebarTabs==1 then page.Visible=true end

        return pages
    end

    return Window
end

return Library
