object ViewFrame: TViewFrame
  Left = 0
  Top = 0
  Width = 655
  Height = 431
  TabOrder = 0
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 655
    Height = 431
    Camera = GLCamera1
    Buffer.BackgroundColor = clBackground
    FieldOfView = 153.874877929687500000
    Align = alClient
    PopupMenu = pmGLScene
    OnMouseDown = GLSceneViewer1MouseDown
    OnMouseMove = GLSceneViewer1MouseMove
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 168
    Top = 72
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      SceneScale = 0.100000001490116100
      TargetObject = GLDummyCubeCenter
      CameraStyle = csOrthogonal
      Position.Coordinates = {00002041000020C1000020410000803F}
      Direction.Coordinates = {F30435BFF304353F0000000000000000}
      Up.Coordinates = {00000000000000000000803F00000000}
    end
    object GLLightSource1: TGLLightSource
      Ambient.Color = {9A99593F9A99593FCDCCCC3D0000803F}
      ConstAttenuation = 1.000000000000000000
      Position.Coordinates = {0000204100002041000020410000803F}
      Specular.Color = {0000803F0000803F0000803F0000803F}
      SpotCutOff = 180.000000000000000000
    end
    object GLDummyCubeCenter: TGLDummyCube
      CubeSize = 1.000000000000000000
      object GLDummyCube1: TGLDummyCube
        CubeSize = 1.000000000000000000
        object GLSphere1: TGLSphere
          Radius = 0.500000000000000000
        end
        object GLLines1: TGLLines
          Nodes = <>
          NodesAspect = lnaInvisible
          Options = []
        end
      end
      object glnsX: TGLLines
        LineColor.Color = {0000803F00000000000000000000803F}
        Nodes = <
          item
          end
          item
            X = 5.000000000000000000
          end>
        NodesAspect = lnaInvisible
        Options = []
      end
      object glnsY: TGLLines
        LineColor.Color = {000000000000003F000000000000803F}
        Nodes = <
          item
          end
          item
            Y = 5.000000000000000000
          end>
        NodesAspect = lnaInvisible
        Options = []
      end
      object glnsZ: TGLLines
        LineColor.Color = {00000000000000000000803F0000803F}
        Nodes = <
          item
          end
          item
            Z = 5.000000000000000000
          end>
        NodesAspect = lnaInvisible
        Options = []
      end
    end
  end
  object pmGLScene: TPopupMenu
    Left = 496
    Top = 128
    object nSelect: TMenuItem
      AutoCheck = True
      Caption = #36873#25321#27169#24335
      OnClick = nSelectClick
    end
  end
end
