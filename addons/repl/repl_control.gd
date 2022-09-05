# REPL editor control
# Copyright (C) 2021  Sylvain Beucler

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

@tool
extends Control

@onready var _input = find_child('input')
@onready var _output = find_child('output')

var _hist := [''];
var _hist_index := 0;

# Import built-in classes
# ClassDB.get_class_list() + fix compile/runtime errors (Godot 3.2.3)
# (this crashes and is incorrect:)
#for name in ClassDB.get_class_list():
#	_variables[name] = ClassDB.instantiate(name)
# Use load() for GDScript classes
#var _variables = {'ClassDB': ClassDB}  # for updating below
var _variables = {
	'XRAnchor3D': XRAnchor3D,
	'XRCamera3D': XRCamera3D,
	'XRController3D': XRController3D,
	'XRInterface': XRInterface,
	'XRInterfaceExtension': XRInterfaceExtension,
	'XROrigin3D': XROrigin3D,
	'XRPositionalTracker': XRPositionalTracker,
	'XRServer': XRServer,
	'AStar3D': AStar3D,
	'AStar2D': AStar2D,
	'AcceptDialog': AcceptDialog,
	'AnimatedSprite2D': AnimatedSprite2D,
	'AnimatedSprite3D': AnimatedSprite3D,
	'AnimatedTexture': AnimatedTexture,
	'Animation': Animation,
	'AnimationNode': AnimationNode,
	'AnimationNodeAdd2': AnimationNodeAdd2,
	'AnimationNodeAdd3': AnimationNodeAdd3,
	'AnimationNodeAnimation': AnimationNodeAnimation,
	'AnimationNodeBlend2': AnimationNodeBlend2,
	'AnimationNodeBlend3': AnimationNodeBlend3,
	'AnimationNodeBlendSpace1D': AnimationNodeBlendSpace1D,
	'AnimationNodeBlendSpace2D': AnimationNodeBlendSpace2D,
	'AnimationNodeBlendTree': AnimationNodeBlendTree,
	'AnimationNodeOneShot': AnimationNodeOneShot,
	'AnimationNodeOutput': AnimationNodeOutput,
	'AnimationNodeStateMachine': AnimationNodeStateMachine,
	'AnimationNodeStateMachinePlayback': AnimationNodeStateMachinePlayback,
	'AnimationNodeStateMachineTransition': AnimationNodeStateMachineTransition,
	'AnimationNodeTimeScale': AnimationNodeTimeScale,
	'AnimationNodeTimeSeek': AnimationNodeTimeSeek,
	'AnimationNodeTransition': AnimationNodeTransition,
	'AnimationPlayer': AnimationPlayer,
	'AnimationRootNode': AnimationRootNode,
	'AnimationTrackEditPlugin': AnimationTrackEditPlugin,
	'AnimationTree': AnimationTree,
	'Area3D': Area3D,
	'Area2D': Area2D,
	'ArrayMesh': ArrayMesh,
	'AtlasTexture': AtlasTexture,
	'AudioBusLayout': AudioBusLayout,
	'AudioEffect': AudioEffect,
	'AudioEffectAmplify': AudioEffectAmplify,
	'AudioEffectBandLimitFilter': AudioEffectBandLimitFilter,
	'AudioEffectBandPassFilter': AudioEffectBandPassFilter,
	'AudioEffectChorus': AudioEffectChorus,
	'AudioEffectCompressor': AudioEffectCompressor,
	'AudioEffectDelay': AudioEffectDelay,
	'AudioEffectDistortion': AudioEffectDistortion,
	'AudioEffectEQ': AudioEffectEQ,
	'AudioEffectEQ10': AudioEffectEQ10,
	'AudioEffectEQ21': AudioEffectEQ21,
	'AudioEffectEQ6': AudioEffectEQ6,
	'AudioEffectFilter': AudioEffectFilter,
	'AudioEffectHighPassFilter': AudioEffectHighPassFilter,
	'AudioEffectHighShelfFilter': AudioEffectHighShelfFilter,
	'AudioEffectInstance': AudioEffectInstance,
	'AudioEffectLimiter': AudioEffectLimiter,
	'AudioEffectLowPassFilter': AudioEffectLowPassFilter,
	'AudioEffectLowShelfFilter': AudioEffectLowShelfFilter,
	'AudioEffectNotchFilter': AudioEffectNotchFilter,
	'AudioEffectPanner': AudioEffectPanner,
	'AudioEffectPhaser': AudioEffectPhaser,
	'AudioEffectPitchShift': AudioEffectPitchShift,
	'AudioEffectRecord': AudioEffectRecord,
	'AudioEffectReverb': AudioEffectReverb,
	'AudioEffectSpectrumAnalyzer': AudioEffectSpectrumAnalyzer,
	'AudioEffectSpectrumAnalyzerInstance': AudioEffectSpectrumAnalyzerInstance,
	'AudioEffectStereoEnhance': AudioEffectStereoEnhance,
	'AudioServer': AudioServer,
	'AudioStream': AudioStream,
	'AudioStreamGenerator': AudioStreamGenerator,
	'AudioStreamGeneratorPlayback': AudioStreamGeneratorPlayback,
	'AudioStreamMicrophone': AudioStreamMicrophone,
	'AudioStreamOggVorbis': AudioStreamOggVorbis,
	'AudioStreamPlayback': AudioStreamPlayback,
	'AudioStreamPlaybackResampled': AudioStreamPlaybackResampled,
	'AudioStreamPlayer': AudioStreamPlayer,
	'AudioStreamPlayer2D': AudioStreamPlayer2D,
	'AudioStreamPlayer3D': AudioStreamPlayer3D,
	'AudioStreamRandomizer': AudioStreamRandomizer,
	'BackBufferCopy': BackBufferCopy,
	'LightmapGI': LightmapGI,
	'LightmapGIData': LightmapGIData,
	'BaseButton': BaseButton,
	'BitMap': BitMap,
	'Font': Font,
	'Bone2D': Bone2D,
	'BoneAttachment3D': BoneAttachment3D,
	'BoxContainer': BoxContainer,
	'BoxShape3D': BoxShape3D,
	'Button': Button,
	'ButtonGroup': ButtonGroup,
	'CPUParticles3D': CPUParticles3D,
	'CPUParticles2D': CPUParticles2D,
	'CSGBox3D': CSGBox3D,
	'CSGCombiner3D': CSGCombiner3D,
	'CSGCylinder3D': CSGCylinder3D,
	'CSGMesh3D': CSGMesh3D,
	'CSGPolygon3D': CSGPolygon3D,
	'CSGPrimitive3D': CSGPrimitive3D,
	'CSGShape3D': CSGShape3D,
	'CSGSphere3D': CSGSphere3D,
	'CSGTorus3D': CSGTorus3D,
	'Camera3D': Camera3D,
	'Camera2D': Camera2D,
	'CameraFeed': CameraFeed,
	'CameraServer': CameraServer,
	'CameraTexture': CameraTexture,
	'CanvasItem': CanvasItem,
	'CanvasItemMaterial': CanvasItemMaterial,
	'CanvasLayer': CanvasLayer,
	'CanvasModulate': CanvasModulate,
	'CapsuleMesh': CapsuleMesh,
	'CapsuleShape3D': CapsuleShape3D,
	'CapsuleShape2D': CapsuleShape2D,
	'CenterContainer': CenterContainer,
	'CharFXTransform': CharFXTransform,
	'CheckBox': CheckBox,
	'CheckButton': CheckButton,
	'CircleShape2D': CircleShape2D,
	'CollisionObject3D': CollisionObject3D,
	'CollisionObject2D': CollisionObject2D,
	'CollisionPolygon3D': CollisionPolygon3D,
	'CollisionPolygon2D': CollisionPolygon2D,
	'CollisionShape3D': CollisionShape3D,
	'CollisionShape2D': CollisionShape2D,
	'ColorPicker': ColorPicker,
	'ColorPickerButton': ColorPickerButton,
	'ColorRect': ColorRect,
	'ConcavePolygonShape3D': ConcavePolygonShape3D,
	'ConcavePolygonShape2D': ConcavePolygonShape2D,
	'ConeTwistJoint3D': ConeTwistJoint3D,
	'ConfigFile': ConfigFile,
	'ConfirmationDialog': ConfirmationDialog,
	'Container': Container,
	'Control': Control,
	'ConvexPolygonShape3D': ConvexPolygonShape3D,
	'ConvexPolygonShape2D': ConvexPolygonShape2D,
	'Crypto': Crypto,
	'CryptoKey': CryptoKey,
	'Cubemap': Cubemap,
	'BoxMesh': BoxMesh,
	'Curve': Curve,
	'Curve2D': Curve2D,
	'Curve3D': Curve3D,
	'CurveTexture': CurveTexture,
	'CylinderMesh': CylinderMesh,
	'CylinderShape3D': CylinderShape3D,
	'DTLSServer': DTLSServer,
	'DampedSpringJoint2D': DampedSpringJoint2D,
	'DirectionalLight3D': DirectionalLight3D,
	'EditorExportPlugin': EditorExportPlugin,
	'EditorFeatureProfile': EditorFeatureProfile,
	'EditorFileDialog': EditorFileDialog,
	'EditorFileSystem': EditorFileSystem,
	'EditorFileSystemDirectory': EditorFileSystemDirectory,
	'EditorImportPlugin': EditorImportPlugin,
	'EditorInspector': EditorInspector,
	'EditorInspectorPlugin': EditorInspectorPlugin,
	'EditorInterface': EditorInterface,
	'EditorPlugin': EditorPlugin,
	'EditorProperty': EditorProperty,
	'EditorResourceConversionPlugin': EditorResourceConversionPlugin,
	'EditorResourcePreview': EditorResourcePreview,
	'EditorResourcePreviewGenerator': EditorResourcePreviewGenerator,
	'EditorSceneFormatImporter': EditorSceneFormatImporter,
	'EditorScenePostImport': EditorScenePostImport,
	'EditorScript': EditorScript,
	'EditorSelection': EditorSelection,
	'EditorSettings': EditorSettings,
	'EditorNode3DGizmo': EditorNode3DGizmo,
	'EditorNode3DGizmoPlugin': EditorNode3DGizmoPlugin,
	'EditorSpinSlider': EditorSpinSlider,
	'EditorVCSInterface': EditorVCSInterface,
	'EncodedObjectAsID': EncodedObjectAsID,
	'Environment': Environment,
	'Expression': Expression,
	'FileDialog': FileDialog,
	'FileSystemDock': FileSystemDock,
	'GDScript': GDScript,
	#'GDScriptNativeClass': GDScriptNativeClass,
	'VoxelGI': VoxelGI,
	'VoxelGIData': VoxelGIData,
	'Generic6DOFJoint3D': Generic6DOFJoint3D,
	'GeometryInstance3D': GeometryInstance3D,
	'Gradient': Gradient,
	'GradientTexture1D': GradientTexture1D,
	'GradientTexture2D': GradientTexture2D,
	'GraphEdit': GraphEdit,
	'GraphNode': GraphNode,
	'GridContainer': GridContainer,
	'GridMap': GridMap,
	'GrooveJoint2D': GrooveJoint2D,
	'HBoxContainer': HBoxContainer,
	'HScrollBar': HScrollBar,
	'HSeparator': HSeparator,
	'HSlider': HSlider,
	'HSplitContainer': HSplitContainer,
	'HTTPClient': HTTPClient,
	'HTTPRequest': HTTPRequest,
	'HashingContext': HashingContext,
	'HeightMapShape3D': HeightMapShape3D,
	'HingeJoint3D': HingeJoint3D,
	'IP': IP,
	'IPUnix': IPUnix,
	'Image': Image,
	'ImageTexture': ImageTexture,
	'ImmediateMesh': ImmediateMesh,
	'Input': Input,
	'InputEvent': InputEvent,
	'InputEventAction': InputEventAction,
	'InputEventGesture': InputEventGesture,
	'InputEventJoypadButton': InputEventJoypadButton,
	'InputEventJoypadMotion': InputEventJoypadMotion,
	'InputEventKey': InputEventKey,
	'InputEventMIDI': InputEventMIDI,
	'InputEventMagnifyGesture': InputEventMagnifyGesture,
	'InputEventMouse': InputEventMouse,
	'InputEventMouseButton': InputEventMouseButton,
	'InputEventMouseMotion': InputEventMouseMotion,
	'InputEventPanGesture': InputEventPanGesture,
	'InputEventScreenDrag': InputEventScreenDrag,
	'InputEventScreenTouch': InputEventScreenTouch,
	'InputEventWithModifiers': InputEventWithModifiers,
	'InputMap': InputMap,
	'InstancePlaceholder': InstancePlaceholder,
	'ItemList': ItemList,
	'JNISingleton': JNISingleton,
	'JSONRPC': JSONRPC,
	'JavaClass': JavaClass,
	'JavaClassWrapper': JavaClassWrapper,
	'JavaScript': JavaScript,
	'Joint3D': Joint3D,
	'Joint2D': Joint2D,
	'CharacterBody3D': CharacterBody3D,
	'CharacterBody2D': CharacterBody2D,
	'KinematicCollision3D': KinematicCollision3D,
	'KinematicCollision2D': KinematicCollision2D,
	'Label': Label,
	'Light3D': Light3D,
	'PointLight2D': PointLight2D,
	'LightOccluder2D': LightOccluder2D,
	'Line2D': Line2D,
	'LineEdit': LineEdit,
	'LinkButton': LinkButton,
	'AudioListener3D': AudioListener3D,
	'MainLoop': MainLoop,
	'MarginContainer': MarginContainer,
	'Material': Material,
	'MenuButton': MenuButton,
	'Mesh': Mesh,
	'MeshDataTool': MeshDataTool,
	'MeshInstance3D': MeshInstance3D,
	'MeshInstance2D': MeshInstance2D,
	'MeshLibrary': MeshLibrary,
	'MeshTexture': MeshTexture,
	'MobileVRInterface': MobileVRInterface,
	'MultiMesh': MultiMesh,
	'MultiMeshInstance3D': MultiMeshInstance3D,
	'MultiMeshInstance2D': MultiMeshInstance2D,
	'MultiplayerAPI': MultiplayerAPI,
	'Node3D': Node3D,
	'Node2D': Node2D,
	'Node3DMesh': Mesh,
	'ENetConnection': ENetConnection,
	'ENetMultiplayerPeer': ENetMultiplayerPeer,
	'NinePatchRect': NinePatchRect,
	'Node': Node,
	'NoiseTexture2D': NoiseTexture2D,
	'OccluderPolygon2D': OccluderPolygon2D,
	'OmniLight3D': OmniLight3D,
	'Noise': Noise,
	'OptionButton': OptionButton,
	'PCKPacker': PCKPacker,
	'OptimizedTranslation': OptimizedTranslation,
	'PackedDataContainer': PackedDataContainer,
	'PackedDataContainerRef': PackedDataContainerRef,
	'PackedScene': PackedScene,
	'PacketPeer': PacketPeer,
	'PacketPeerDTLS': PacketPeerDTLS,
	'PacketPeerStream': PacketPeerStream,
	'PacketPeerUDP': PacketPeerUDP,
	'Panel': Panel,
	'PanelContainer': PanelContainer,
	'PanoramaSkyMaterial': PanoramaSkyMaterial,
	'ParallaxBackground': ParallaxBackground,
	'ParallaxLayer': ParallaxLayer,
	'GPUParticles3D': GPUParticles3D,
	'GPUParticles2D': GPUParticles2D,
	'ParticleProcessMaterial': ParticleProcessMaterial,
	'Path3D': Path3D,
	'Path2D': Path2D,
	'PathFollow3D': PathFollow3D,
	'PathFollow2D': PathFollow2D,
	'Performance': Performance,
	'PhysicalBone3D': PhysicalBone3D,
	'PhysicsDirectBodyState2D': PhysicsDirectBodyState2D,
	'PhysicsDirectSpaceState2D': PhysicsDirectSpaceState2D,
	'PhysicsServer2D': PhysicsServer2D,
	'PhysicsShapeQueryParameters2D': PhysicsShapeQueryParameters2D,
	'PhysicsTestMotionResult2D': PhysicsTestMotionResult2D,
	'PhysicsBody3D': PhysicsBody3D,
	'PhysicsBody2D': PhysicsBody2D,
	'PhysicsDirectBodyState3D': PhysicsDirectBodyState3D,
	'PhysicsDirectSpaceState3D': PhysicsDirectSpaceState3D,
	'PhysicsMaterial': PhysicsMaterial,
	'PhysicsServer3D': PhysicsServer3D,
	'PhysicsShapeQueryParameters3D': PhysicsShapeQueryParameters3D,
	'PinJoint3D': PinJoint3D,
	'PinJoint2D': PinJoint2D,
	'PlaneMesh': PlaneMesh,
	'WorldMarginShape3D': WorldBoundaryShape3D,
	'ScriptLanguageExtension': ScriptLanguageExtension,
	'PointMesh': PointMesh,
	'Polygon2D': Polygon2D,
	'PolygonPathFinder': PolygonPathFinder,
	'Popup': Popup,
	'PopupMenu': PopupMenu,
	'PopupPanel': PopupPanel,
	'Marker2D': Marker2D,
	'Marker3D': Marker3D,
	'PrimitiveMesh': PrimitiveMesh,
	'PrismMesh': PrismMesh,
	'Sky': Sky,
	'ProgressBar': ProgressBar,
	'ProjectSettings': ProjectSettings,
	'RandomNumberGenerator': RandomNumberGenerator,
	'Range': Range,
	'RayCast3D': RayCast3D,
	'RayCast2D': RayCast2D,
	'RectangleShape2D': RectangleShape2D,
	'RefCounted': RefCounted,
	'ReferenceRect': ReferenceRect,
	'ReflectionProbe': ReflectionProbe,
	'RegEx': RegEx,
	'RegExMatch': RegExMatch,
	'RemoteTransform3D': RemoteTransform3D,
	'RemoteTransform2D': RemoteTransform2D,
	'Resource': Resource,
	'ResourceFormatLoader': ResourceFormatLoader,
	'ResourceFormatSaver': ResourceFormatSaver,
	'ResourceImporter': ResourceImporter,
	'ResourcePreloader': ResourcePreloader,
	'RichTextEffect': RichTextEffect,
	'RichTextLabel': RichTextLabel,
	'RigidBody3D': RigidBody3D,
	'RigidBody2D': RigidBody2D,
	'RootMotionView': RootMotionView,
	'SceneState': SceneState,
	'SceneTree': SceneTree,
	'SceneTreeTimer': SceneTreeTimer,
	'Script': Script,
	'ScriptCreateDialog': ScriptCreateDialog,
	'ScriptEditor': ScriptEditor,
	'ScrollBar': ScrollBar,
	'ScrollContainer': ScrollContainer,
	'SegmentShape2D': SegmentShape2D,
	'Separator': Separator,
	'Shader': Shader,
	'ShaderMaterial': ShaderMaterial,
	'Shape3D': Shape3D,
	'Shape2D': Shape2D,
	'Shortcut': Shortcut,
	'Skeleton3D': Skeleton3D,
	'Skeleton2D': Skeleton2D,
	'SkeletonIK3D': SkeletonIK3D,
	'Skin': Skin,
	'SkinReference': SkinReference,
	'Slider': Slider,
	'SliderJoint3D': SliderJoint3D,
	'SoftBody3D': SoftBody3D,
	'StandardMaterial3D': StandardMaterial3D,
	'SphereMesh': SphereMesh,
	'SphereShape3D': SphereShape3D,
	'SpinBox': SpinBox,
	'SplitContainer': SplitContainer,
	'SpotLight3D': SpotLight3D,
	'SpringArm3D': SpringArm3D,
	'Sprite2D': Sprite2D,
	'Sprite3D': Sprite3D,
	'SpriteBase3D': SpriteBase3D,
	'SpriteFrames': SpriteFrames,
	'StarScript': StarScript,
	'StarScriptParser': StarScriptParser,
	'StaticBody3D': StaticBody3D,
	'StaticBody2D': StaticBody2D,
	'StreamPeer': StreamPeer,
	'StreamPeerBuffer': StreamPeerBuffer,
	'StreamPeerSSL': StreamPeerSSL,
	'StreamPeerTCP': StreamPeerTCP,
	'StyleBox': StyleBox,
	'StyleBoxEmpty': StyleBoxEmpty,
	'StyleBoxFlat': StyleBoxFlat,
	'StyleBoxLine': StyleBoxLine,
	'StyleBoxTexture': StyleBoxTexture,
	'SurfaceTool': SurfaceTool,
	'TCPServer': TCPServer,
	'TabContainer': TabContainer,
	'TextEdit': TextEdit,
	'Texture2D': Texture2D,
	'Texture3D': Texture3D,
	'Texture2DArray': Texture2DArray,
	'TextureButton': TextureButton,
	'TextureLayered': TextureLayered,
	'TextureProgressBar': TextureProgressBar,
	'TextureRect': TextureRect,
	'Theme': Theme,
	'TileMap': TileMap,
	'TileSet': TileSet,
	'Timer': Timer,
	'TouchScreenButton': TouchScreenButton,
	'Translation': Translation,
	'TranslationServer': TranslationServer,
	'Tree': Tree,
	'TreeItem': TreeItem,
	'TriangleMesh': TriangleMesh,
	'Tween': Tween,
	'UDPServer': UDPServer,
	'UPNP': UPNP,
	'UPNPDevice': UPNPDevice,
	'UndoRedo': UndoRedo,
	'VBoxContainer': VBoxContainer,
	'VScrollBar': VScrollBar,
	'VSeparator': VSeparator,
	'VSlider': VSlider,
	'VSplitContainer': VSplitContainer,
	'VehicleBody3D': VehicleBody3D,
	'VehicleWheel3D': VehicleWheel3D,
	'VideoStream': VideoStream,
	'VideoStreamTheora': VideoStreamTheora,
	'SubViewport': SubViewport,
	'SubViewportContainer': SubViewportContainer,
	'ViewportTexture': ViewportTexture,
	'VisibleOnScreenEnabler3D': VisibleOnScreenEnabler3D,
	'VisibleOnScreenEnabler2D': VisibleOnScreenEnabler2D,
	'VisibleOnScreenNotifier3D': VisibleOnScreenNotifier3D,
	'VisibleOnScreenNotifier2D': VisibleOnScreenNotifier2D,
	'VisualInstance3D': VisualInstance3D,
	'RenderingServer': RenderingServer,
	'VisualShader': VisualShader,
	'VisualShaderNode': VisualShaderNode,
	'VisualShaderNodeBooleanConstant': VisualShaderNodeBooleanConstant,
	'VisualShaderNodeBooleanUniform': VisualShaderNodeBooleanUniform,
	'VisualShaderNodeColorConstant': VisualShaderNodeColorConstant,
	'VisualShaderNodeColorFunc': VisualShaderNodeColorFunc,
	'VisualShaderNodeColorOp': VisualShaderNodeColorOp,
	'VisualShaderNodeColorUniform': VisualShaderNodeColorUniform,
	'VisualShaderNodeCompare': VisualShaderNodeCompare,
	'VisualShaderNodeCubemap': VisualShaderNodeCubemap,
	'VisualShaderNodeCubemapUniform': VisualShaderNodeCubemapUniform,
	'VisualShaderNodeCustom': VisualShaderNodeCustom,
	'VisualShaderNodeDeterminant': VisualShaderNodeDeterminant,
	'VisualShaderNodeDotProduct': VisualShaderNodeDotProduct,
	'VisualShaderNodeExpression': VisualShaderNodeExpression,
	'VisualShaderNodeFaceForward': VisualShaderNodeFaceForward,
	'VisualShaderNodeFresnel': VisualShaderNodeFresnel,
	'VisualShaderNodeGlobalExpression': VisualShaderNodeGlobalExpression,
	'VisualShaderNodeGroupBase': VisualShaderNodeGroupBase,
	'VisualShaderNodeIf': VisualShaderNodeIf,
	'VisualShaderNodeInput': VisualShaderNodeInput,
	'VisualShaderNodeIs': VisualShaderNodeIs,
	'VisualShaderNodeOuterProduct': VisualShaderNodeOuterProduct,
	'VisualShaderNodeOutput': VisualShaderNodeOutput,
	'VisualShaderNodeClamp': VisualShaderNodeClamp,
	'VisualShaderNodeConstant': VisualShaderNodeConstant,
	'VisualShaderNodeDerivativeFunc': VisualShaderNodeDerivativeFunc,
	'VisualShaderNodeSmoothStep': VisualShaderNodeSmoothStep,
	'VisualShaderNodeSwitch': VisualShaderNodeSwitch,
	'VisualShaderNodeUniform': VisualShaderNodeUniform,
	'VisualShaderNodeTexture': VisualShaderNodeTexture,
	'VisualShaderNodeTextureUniform': VisualShaderNodeTextureUniform,
	'VisualShaderNodeTextureUniformTriplanar': VisualShaderNodeTextureUniformTriplanar,
	'VisualShaderNodeTransformCompose': VisualShaderNodeTransformCompose,
	'VisualShaderNodeTransformConstant': VisualShaderNodeTransformConstant,
	'VisualShaderNodeTransformDecompose': VisualShaderNodeTransformDecompose,
	'VisualShaderNodeTransformFunc': VisualShaderNodeTransformFunc,
	'VisualShaderNodeTransformUniform': VisualShaderNodeTransformUniform,
	'VisualShaderNodeTransformVecMult': VisualShaderNodeTransformVecMult,
	'VisualShaderNodeVec3Constant': VisualShaderNodeVec3Constant,
	'VisualShaderNodeVec3Uniform': VisualShaderNodeVec3Uniform,
	'VisualShaderNodeVectorCompose': VisualShaderNodeVectorCompose,
	'VisualShaderNodeVectorDecompose': VisualShaderNodeVectorDecompose,
	'VisualShaderNodeVectorDistance': VisualShaderNodeVectorDistance,
	'VisualShaderNodeVectorFunc': VisualShaderNodeVectorFunc,
	'VisualShaderNodeVectorLen': VisualShaderNodeVectorLen,
	'VisualShaderNodeVectorOp': VisualShaderNodeVectorOp,
	'VisualShaderNodeVectorRefract': VisualShaderNodeVectorRefract,
	'VisualShaderNodeMix': VisualShaderNodeMix,
	'VisualShaderNodeStep': VisualShaderNodeStep,
	'WeakRef': WeakRef,
	'WebRTCDataChannel': WebRTCDataChannel,
	'WebRTCPeerConnection': WebRTCPeerConnection,
	'WebSocketClient': WebSocketClient,
	'WebSocketMultiplayerPeer': WebSocketMultiplayerPeer,
	'WebSocketPeer': WebSocketPeer,
	'WebSocketServer': WebSocketServer,
	'World3D': World3D,
	'World2D': World2D,
	'WorldEnvironment': WorldEnvironment,
	'X509Certificate': X509Certificate,
	'XMLParser': XMLParser,
	'ClassDB': ClassDB,
	'Directory': Directory,
	'Engine': Engine,
	'File': File,
	'JSON': JSON,
	'Marshalls': Marshalls,
	'Mutex': Mutex,
	'OS': OS,
	'ResourceLoader': ResourceLoader,
	'ResourceSaver': ResourceSaver,
	'Semaphore': Semaphore,
	'Thread': Thread,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_input.grab_focus()
	
	_variables.clear = func(): $VBoxContainer/output.clear()

func gd_eval(gd_expr: String) -> Array:
	var errstr = 'Error: '
	var expression = Expression.new()
	var error = expression.parse(gd_expr, _variables.keys())
	if error != OK:
		errstr += 'invalid expression: '
		errstr += expression.get_error_text()
		return [false, errstr]
	var result = expression.execute(_variables.values())
	if expression.has_execute_failed():
		errstr += 'execute failed: '
		var gderr = expression.get_error_text()
		if gderr == "self can't be used because instance is null (not passed)":
			gderr += ' [variable not declared?]'
		errstr += gderr
		return [false, errstr]
	return [true, result]

func gui_eval(input:Node, output:Node) -> void:
	if input.text == '':
		output.text += '> \n'
		return
	
	_hist[len(_hist)-1] = input.text
	_hist.push_back('')
	_hist_index = len(_hist) - 1
	
	output.text += '> ' + input.text + '\n'
	
	var ret = null
	
	# Assignment re-implementation (missing in Expression)
	# TODO: d[x] += 1
	var var_name = null
	var regex_var = RegEx.new()
	var result
	regex_var.compile("^\\s*(var\\s+)?(?<variable>[a-zA-Z_][a-zA-Z_0-9]*)\\s*?=\\s*?(?<rest>.*)")
	result = regex_var.search(input.text)
	if result:
		var_name = result.get_string('variable')
		input.text = result.get_string('rest')
	
	# load() support
	var path = null
	var regex_load = RegEx.new()
	regex_load.compile("^load\\(\"(?<path>[^\\\"]*)\"\\)|load\\(\'(?<path>[^\\\"]*)\'\\)")
	result = regex_load.search(input.text)
	if result:
		path = result.get_string('path')
		ret = load(path)
		ret = [true, ret]
	
	if ret == null:
		ret = gd_eval(input.text)
	
	if var_name != null and ret[0]:
		output.text += '* setting variable %s *\n' % var_name
		_variables[var_name] = ret[1]
	
	output.text += str(ret[1]) + "\n"
	input.text = ''
	
	input.grab_focus()


func _on_eval_pressed():
	gui_eval(_input, _output)

func _on_input_text_entered(_new_text):
	gui_eval(_input, _output)

func _on_import_pressed():
	if _input.text.is_empty():
		_output.text += 'Please type a variable name.\n'
		_input.grab_focus()
		return
	find_child('import_filedialog').popup()

func _on_import_filedialog_file_selected(path):
	var name = _input.text
	_variables[name] = load(path).instantiate()
	_output.text += '> %s = %s\n' % [name, _variables[name]]
	_input.text = ''
	_input.grab_focus()

func _on_input_gui_input(event):
	if event.is_action_pressed('ui_up'):
		_hist[_hist_index] = _input.text
		_hist_index = _hist_index-1 if (_hist_index > 0) else _hist_index
		_input.text = _hist[_hist_index]
		_input.caret_position = len(_input.text)
		accept_event()
	if event.is_action_pressed('ui_down'):
		_hist[_hist_index] = _input.text
		_hist_index = _hist_index+1 if (_hist_index < len(_hist)-1) else _hist_index
		_input.text = _hist[_hist_index]
		_input.caret_position = len(_input.text)
		accept_event()

# TODO: reset button
# TODO: i18n
