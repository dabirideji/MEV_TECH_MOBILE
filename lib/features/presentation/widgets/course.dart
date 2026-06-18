class Course {
  const Course({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.durationType,
    required this.duration,
    this.category = all,
  });
  final String id;
  final String imagePath;
  final String title;
  final String durationType;
  final String duration;
  final String category;

  static const all = 'All Categories';
  static const aiMarchineLearning = 'Ai & Machine Learning';
  static const business = 'Business';
  static const marketing = 'Marketing & Communication';
  static const dataScience = 'Data Science';
  static const finance = 'Finance & Investing';
  static const softwareDev = 'Software Development';
  static const workplaceTech = 'Workplace Technology';
  static const health = 'Health & Wellness';
  static const education = 'Education & Teaching';
  static const education2 = 'Personal Education';
  static const engineering = 'Engineering';
  static const design = 'Design & Creativity';
  static const supplyChain = 'Supply Chain';
  static const publicAdmin = 'Public Administration';
  static const hospitality = 'Hospitality & Tourism';
  static const agriculture = 'Agriculture & Environment';

  static List<String> categoryItems = [
    aiMarchineLearning,
    business,
    marketing,
    dataScience,
    finance,
    softwareDev,
    workplaceTech,
    health,
    education,
    education2,
    engineering,
    design,
    supplyChain,
    publicAdmin,
    hospitality,
    agriculture,
  ];

  static String allTags = 'General';

  static List<Map<String, List<String>>> categoryTags = [
    {
      softwareDev: [
        'Python',
        'Flutter',
        'HTML',
        'CSS',
        'JavaScript',
        'Dart',
        'APIs',
        'React',
        'Node.js',
      ],
    },
    {
      business: [
        'Leadership',
        'Project Management',
        'Business Strategy',
        'HR',
        'Entrepreneurship',
        'Customer Service',
      ],
    },
    {
      design: [
        'UI/UX',
        'Figma',
        'Canva',
        'Photoshop',
        'Illustration',
        'Typography',
        'Branding',
        'Logo Design',
      ],
    },
    {
      marketing: [
        'SEO',
        'Email Marketing',
        'Facebook Ads',
        'Content Creation',
        'Analytics',
        'Social Media',
        'Influencer Marketing',
      ],
    },
    {
      dataScience: [
        'Power BI',
        'Pandas',
        'Excel',
        'SQL',
        'Data Cleaning',
        'Visualization',
        'Machine Learning',
        'Statistics',
      ],
    },
    {
      health: [
        'Nutrition',
        'Mental Health',
        'Fitness',
        'Yoga',
        'First Aid',
        'Well-being',
        'Sleep',
        'Meditation',
      ],
    },
    {
      finance: [
        'QuickBooks',
        'Taxes',
        'Investment',
        'Financial Modeling',
        'Auditing',
        'Personal Finance',
      ],
    },
    {
      education: [
        'Classroom Management',
        'Curriculum Design',
        'EdTech',
        'Special Education',
        'Assessment',
        'Online Teaching',
        'Lesson Planning',
      ],
    },
    {
      education2: [
        'English',
        'French',
        'Spanish',
        'IELTS',
        'TOEFL',
        'Grammar',
      ],
    },
    {
      engineering: [
        'Physics',
        'Chemistry',
        'Mathematics',
        'Mechanical Engineering',
        'Electrical Engineering',
        'Thermodynamics',
        'Robotics',
      ],
    },
    {
      publicAdmin: [
        'Constitutional Law',
        'Criminal Law',
        'Public Administration',
        'Civic Education',
        'Legal Drafting',
        'International Law',
      ],
    },
    {
      agriculture: [
        'Crop Science',
        'Soil Science',
        'Irrigation',
        'Organic Farming',
        'Environmental Science',
        'Sustainability',
        'AgriTech',
      ],
    },
    {
      workplaceTech: [
        'News Writing',
        'Broadcasting',
        'Media Ethics',
        'Video Editing',
        'Scriptwriting',
      ],
    },
    {
      hospitality: [
        'Event Planning',
        'Hotel Management',
        'Customer Experience',
        'Travel Planning',
        'Culinary Arts',
        'Tour Guiding',
      ],
    },
    {
      supplyChain: [
        'Supply Chain',
        'Fleet Management',
        'Inventory Control',
        'Logistics Software',
        'Warehouse Management',
        'Transport Economics',
      ],
    },
    {
      aiMarchineLearning: [
        'Neural Networks',
        'Deep Learning',
        'Natural Language Processing',
        'TensorFlow',
        'Supervised Learning',
        'AI Ethics',
        'Computer Vision',
      ],
    },
  ];
}
