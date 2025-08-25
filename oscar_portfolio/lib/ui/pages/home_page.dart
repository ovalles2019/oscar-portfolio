import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/nav_bar.dart';
import '../widgets/section.dart';
import '../widgets/project_card.dart';
import '../../models/project.dart';
import '../../data/projects.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: NavBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HeroSection(),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Section(
                    title: "About Me",
                    subtitle: "Passionate Cloud Engineer with expertise in AWS and modern development",
                    child: _AboutSection(),
                  ),
                  Section(
                    title: "Projects",
                    subtitle: "Showcasing my latest work and technical achievements",
                    child: _ProjectsSection(),
                  ),
                  Section(
                    title: "Skills & Technologies",
                    subtitle: "Technologies I work with and areas of expertise",
                    child: _SkillsSection(),
                  ),
                  Section(
                    title: "Get In Touch",
                    subtitle: "Let's discuss how we can work together",
                    child: _ContactSection(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.0),
          ],
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: const AssetImage('assets/avatar.jpg'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          const SizedBox(height: 32),
          Text(
            "Oscar Valles",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Cloud Engineer & Full-Stack Developer",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Building scalable cloud solutions with AWS, Flutter, and modern technologies. "
            "Passionate about creating efficient, reliable, and user-friendly applications.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _launchUrl('assets/resume.pdf'),
                icon: const Icon(Icons.download),
                label: const Text("Download Resume"),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => _scrollToSection(context, "contact"),
                icon: const Icon(Icons.email),
                label: const Text("Get In Touch"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _scrollToSection(BuildContext context, String section) {
    // Implementation for smooth scrolling
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scrolling to $section section...')),
    );
  }

  Future<void> _launchUrl(String url) async {
    // For resume download - in a real app, this would download the file
    // For now, we'll just show a message in the console
    print('Resume download requested for: $url');
  }
}

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "I'm a Cloud Engineer with a passion for building scalable, efficient solutions. "
          "My expertise lies in AWS cloud services, serverless architectures, and modern web development. "
          "I love tackling complex problems and turning ideas into reality through clean, maintainable code.",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.cloud,
                title: "Cloud Solutions",
                description: "AWS, Serverless, Microservices",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatCard(
                icon: Icons.code,
                title: "Full-Stack Development",
                description: "Flutter, Web, Mobile Apps",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatCard(
                icon: Icons.architecture,
                title: "System Design",
                description: "Scalable, Reliable, Efficient",
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: demoProjects.map((p) => ProjectCard(project: p)).toList(),
    );
  }
}

class _SkillsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final skills = {
      "Cloud & DevOps": ["AWS", "Docker", "Kubernetes", "CI/CD", "Terraform"],
      "Programming": ["Dart/Flutter", "Python", "JavaScript", "TypeScript", "Java"],
      "Databases": ["DynamoDB", "PostgreSQL", "MongoDB", "Redis"],
      "Tools & Frameworks": ["Git", "VS Code", "Postman", "Jira", "Confluence"],
    };

    return Column(
      children: skills.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: entry.value
                    .map((skill) => Chip(
                          label: Text(skill),
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "I'm always interested in new opportunities and exciting projects. "
          "Whether you have a question or just want to say hi, feel free to reach out!",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ContactButton(
              icon: Icons.email,
              title: "Email",
              onTap: () => _launchUrl('mailto:oscar@example.com'),
            ),
            const SizedBox(width: 16),
            _ContactButton(
              icon: Icons.link,
              title: "LinkedIn",
              onTap: () => _launchUrl('https://linkedin.com/in/oscarvalles'),
            ),
            const SizedBox(width: 16),
            _ContactButton(
              icon: Icons.code,
              title: "GitHub",
              onTap: () => _launchUrl('https://github.com/oscarvalles'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ContactButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
