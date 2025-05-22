import 'package:flutter/material.dart';
import '../services/youtube_service.dart';
import 'package:url_launcher/url_launcher.dart';

class YouTubePreview extends StatefulWidget {
  final String guitarModel;

  const YouTubePreview({
    super.key,
    required this.guitarModel,
  });

  @override
  State<YouTubePreview> createState() => _YouTubePreviewState();
}

class _YouTubePreviewState extends State<YouTubePreview> {
  List<Map<String, dynamic>> _videos = [];
  List<Map<String, dynamic>> _tutorials = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadYouTubeData();
  }

  Future<void> _loadYouTubeData() async {
    try {
      final videos = await YouTubeService.searchGuitarVideos(widget.guitarModel);
      final tutorials = await YouTubeService.searchGuitarTutorials(widget.guitarModel);
      
      if (mounted) {
        setState(() {
          _videos = videos;
          _tutorials = tutorials;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _launchYouTubeVideo(String videoId) async {
    final url = 'https://www.youtube.com/watch?v=$videoId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open YouTube')),
        );
      }
    }
  }

  Widget _buildVideoList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Reviews & Demos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              final video = _videos[index];
              final videoId = video['id']['videoId'];
              final thumbnail = video['snippet']['thumbnails']['high']['url'];
              
              return GestureDetector(
                onTap: () => _launchYouTubeVideo(videoId),
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              thumbnail,
                              height: 157,
                              width: 280,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        video['snippet']['title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTutorialList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Tutorials & Lessons',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tutorials.length,
          itemBuilder: (context, index) {
            final tutorial = _tutorials[index];
            final videoId = tutorial['id']['videoId'];
            final thumbnail = tutorial['snippet']['thumbnails']['default']['url'];
            
            return ListTile(
              onTap: () => _launchYouTubeVideo(videoId),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  thumbnail,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                tutorial['snippet']['title'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                tutorial['snippet']['channelTitle'],
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: const Icon(Icons.play_arrow, color: Colors.red),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load YouTube data',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadYouTubeData();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_videos.isEmpty && _tutorials.isEmpty) {
      return const Center(
        child: Text('No YouTube content found for this guitar'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (_videos.isNotEmpty) _buildVideoList(),
          if (_tutorials.isNotEmpty) _buildTutorialList(),
        ],
      ),
    );
  }
} 