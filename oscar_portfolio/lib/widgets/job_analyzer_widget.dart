import 'package:flutter/material.dart';

class JobAnalyzerWidget extends StatefulWidget {
  const JobAnalyzerWidget({super.key});

  @override
  State<JobAnalyzerWidget> createState() => _JobAnalyzerWidgetState();
}

class _JobAnalyzerWidgetState extends State<JobAnalyzerWidget>
    with TickerProviderStateMixin {
  final TextEditingController _jobDescriptionController = TextEditingController();
  late AnimationController _analysisController;
  late Animation<double> _analysisAnimation;
  
  List<SkillMatch> _skillMatches = [];
  bool _isAnalyzing = false;
  double _overallMatch = 0.0;

  final Map<String, double> _oscarSkills = {
    'AWS': 0.95,
    'Cloud Computing': 0.90,
    'Flutter': 0.95,
    'Dart': 0.90,
    'Python': 0.85,
    'JavaScript': 0.80,
    'TypeScript': 0.75,
    'Docker': 0.85,
    'Kubernetes': 0.80,
    'Terraform': 0.75,
    'CI/CD': 0.90,
    'DevOps': 0.90,
    'Microservices': 0.85,
    'Serverless': 0.90,
    'API Development': 0.90,
    'REST APIs': 0.90,
    'GraphQL': 0.70,
    'PostgreSQL': 0.80,
    'MongoDB': 0.75,
    'DynamoDB': 0.85,
    'Redis': 0.70,
    'Machine Learning': 0.75,
    'AI': 0.80,
    'TensorFlow': 0.70,
    'PyTorch': 0.65,
    'Data Science': 0.75,
    'React': 0.70,
    'Node.js': 0.75,
    'Git': 0.95,
    'Linux': 0.85,
    'Agile': 0.90,
    'Scrum': 0.85,
  };

  @override
  void initState() {
    super.initState();
    _analysisController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _analysisAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _analysisController,
      curve: Curves.easeOutCubic,
    ));

    // Sample job description
    _jobDescriptionController.text = '''We are looking for a Senior Cloud Engineer with expertise in:
- AWS services (Lambda, EC2, S3, DynamoDB)
- Flutter and mobile development
- Python and JavaScript programming
- Docker and Kubernetes
- CI/CD pipelines and DevOps practices
- Microservices architecture
- Machine Learning and AI integration
- Strong problem-solving skills''';
  }

  @override
  void dispose() {
    _jobDescriptionController.dispose();
    _analysisController.dispose();
    super.dispose();
  }

  void _analyzeJob() async {
    if (_jobDescriptionController.text.trim().isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _skillMatches.clear();
    });

    _analysisController.reset();
    _analysisController.forward();

    // Simulate analysis time
    await Future.delayed(const Duration(milliseconds: 2000));

    final jobText = _jobDescriptionController.text.toLowerCase();
    final matches = <SkillMatch>[];

    for (final skill in _oscarSkills.keys) {
      final skillLower = skill.toLowerCase();
      if (jobText.contains(skillLower) || 
          _hasRelatedKeywords(jobText, skillLower)) {
        matches.add(SkillMatch(
          skill: skill,
          match: _oscarSkills[skill]!,
          relevance: _calculateRelevance(jobText, skillLower),
        ));
      }
    }

    // Sort by relevance and match score
    matches.sort((a, b) => (b.relevance * b.match).compareTo(a.relevance * a.match));

    // Calculate overall match
    final overallMatch = matches.isEmpty 
        ? 0.0 
        : matches.map((m) => m.match * m.relevance).reduce((a, b) => a + b) / matches.length;

    setState(() {
      _skillMatches = matches;
      _overallMatch = overallMatch;
      _isAnalyzing = false;
    });
  }

  bool _hasRelatedKeywords(String jobText, String skill) {
    final relatedKeywords = {
      'aws': ['amazon web services', 'cloud', 'lambda', 'ec2', 's3', 'dynamodb'],
      'flutter': ['mobile development', 'cross-platform', 'dart'],
      'python': ['programming', 'backend', 'data science'],
      'docker': ['containerization', 'containers'],
      'kubernetes': ['k8s', 'orchestration'],
      'devops': ['ci/cd', 'deployment', 'automation'],
      'machine learning': ['ml', 'ai', 'artificial intelligence'],
    };

    final keywords = relatedKeywords[skill] ?? [];
    return keywords.any((keyword) => jobText.contains(keyword));
  }

  double _calculateRelevance(String jobText, String skill) {
    double relevance = 0.5; // Base relevance
    
    // Increase relevance based on keyword frequency
    final skillCount = skill.allMatches(jobText).length;
    relevance += skillCount * 0.1;
    
    // Increase relevance for exact matches
    if (jobText.contains(skill)) {
      relevance += 0.3;
    }
    
    return relevance.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.analytics,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Job Description Analyzer',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Match your skills to job requirements',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Job description input
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paste job description:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: TextField(
                    controller: _jobDescriptionController,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'Paste the job description here...',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing ? null : _analyzeJob,
                    icon: _isAnalyzing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.analytics),
                    label: Text(_isAnalyzing ? 'Analyzing...' : 'Analyze Match'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Results
          if (_skillMatches.isNotEmpty)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Overall match
                    AnimatedBuilder(
                      animation: _analysisAnimation,
                      builder: (context, child) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _getMatchColor(_overallMatch).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getMatchColor(_overallMatch).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: _getMatchColor(_overallMatch),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Overall Match',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: _getMatchColor(_overallMatch),
                                      ),
                                    ),
                                    Text(
                                      '${(_overallMatch * 100).toInt()}% compatibility',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: _getMatchColor(_overallMatch),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CircularProgressIndicator(
                                value: _overallMatch * _analysisAnimation.value,
                                backgroundColor: _getMatchColor(_overallMatch).withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation(_getMatchColor(_overallMatch)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Skill matches
                    Expanded(
                      child: ListView.builder(
                        itemCount: _skillMatches.length,
                        itemBuilder: (context, index) {
                          final match = _skillMatches[index];
                          return AnimatedBuilder(
                            animation: _analysisAnimation,
                            builder: (context, child) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            match.skill,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${(match.match * 100).toInt()}% proficiency',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 60,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: match.match * _analysisAnimation.value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: _getMatchColor(match.match),
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getMatchColor(double match) {
    if (match >= 0.8) return Colors.green;
    if (match >= 0.6) return Colors.orange;
    return Colors.red;
  }
}

class SkillMatch {
  final String skill;
  final double match;
  final double relevance;

  SkillMatch({
    required this.skill,
    required this.match,
    required this.relevance,
  });
}
