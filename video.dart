import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

 const appId = "600b111bfa3549389bae7deaccc09dd1";
const token =
    "007eJxTYJibvuV+71PuIFGnxpLZR15OnG+hkV2Wd8LktavDtK+3kpkUGMwMDJIMDQ2T0hKNTU0sjS0skxJTzVNSE5OTkw0sU1IMGV3b0hoCGRn0qkVYGRkgEMTnZCiLT07MycnMS2dgAAAARCDl";
const channel = "v_calling";

class _VideoCallState extends State<VideoCall> {
  //
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _localUserMic = true;
  bool _localUsermiMiSpeaker = false;
  bool _localUsermiScreenRatio = false;
  bool _isCameraOn = true;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    
    await _engine.enableVideo();

    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }



  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Center(
            child: _localUsermiScreenRatio?_remoteVideo():_localUserJoined
                ? AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine,
                canvas: const VideoCanvas(uid: 0),
              ),
            )
                : const CircularProgressIndicator(),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                _localUsermiScreenRatio=!_localUsermiScreenRatio;
              });

            },
            child: SizedBox(
              height: 100,
              width: 100,
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child:_localUsermiScreenRatio? Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ):_remoteVideo(),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.transparent)),
                onPressed: () {
                  _engine.switchCamera();
                },
                child: Icon(
                  Icons.flip_camera_ios_outlined,
                  color: Colors.white,
                  size: 25,
                )),
          ),
          Positioned(
            bottom: 20,
            left: 100,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.transparent)),
                onPressed: () {
                  print("----------------------------start---------------------------");
                  // _engine.muteLocalAudioStream(_localUserJoined);
                  setState(() {
                    // Toggle the local user's audio stream
                    _localUserMic = !_localUserMic;

                    // Mute/unmute the local audio stream based on the new value
                    _engine.muteLocalAudioStream(!_localUserMic);
                  });

                  print("----------------------------finish---------------------------");
                },
                child: Icon(
                  _localUserMic

                  ?Icons.mic_outlined

                  :Icons.mic_off_outlined,  // Microphone on icon
                  color: Colors.white,
                  size: 25,
                )),
          ),
          Positioned(
            bottom: 20,
            right:10 ,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.transparent)),
                onPressed: () {
                  print("----------------------------start---------------------------");
                  // _engine.muteLocalAudioStream(_localUserJoined);
                  setState(() {
                    // Toggle the local user's audio stream
                    _localUsermiMiSpeaker = !_localUsermiMiSpeaker;

                    // Mute/unmute the local audio stream based on the new value
                    _engine.setEnableSpeakerphone(_localUsermiMiSpeaker);
                  });

                  print("----------------------------finish---------------------------");
                },
                child: Icon(
                 _localUsermiMiSpeaker
                      ? Icons.speaker  // Microphone on icon
                      : Icons.speaker_group,
                  color: Colors.white,
                  size: 25,
                )),
          ),
          Positioned(
            bottom: 20,
            right:100 ,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.red)),
                onPressed: () {
                  print("----------------------------start---------------------------");
                  // _engine.muteLocalAudioStream(_localUserJoined);
                  setState(() {
                    _dispose();
                  });
                  Navigator.of(context).pop();
                  print("----------------------------finish---------------------------");
                },
                child: Icon(

                       Icons.call_end_rounded , // Microphone on icon

                  color: Colors.white,
                  size: 25,
                )),
          ),
          Positioned(
            bottom: 100,
            right: 10,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent,
                ),
              ),
              onPressed: () {
                print("----------------------------toggle camera---------------------------");

                // Use setState to trigger a rebuild
                setState(() {
                  // Toggle the local user's camera
                  _toggleCamera();
                });
              },
              child: Icon(
                _isCameraOn
                    ? Icons.videocam  // Camera on icon
                    : Icons.videocam_off,  // Camera off icon
                color: Colors.white,
                size: 25,
              ),
            ),
          ),

        ],
      ),
    );
  }

  void _toggleCamera() {
    // Toggle the camera state
    _isCameraOn = !_isCameraOn;

    // Enable or disable the local video stream based on the new value
    _engine.enableLocalVideo(_isCameraOn);
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
    );
}
}
}