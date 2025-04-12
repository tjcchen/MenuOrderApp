# Guide to Publishing Your Menu Order App on the China iOS App Store

Publishing an app to the China iOS App Store involves some specific requirements beyond the standard App Store process. Here's a comprehensive guide to help you navigate this process:

## Pre-Submission Requirements

### 1. China-Specific Legal Requirements

- **ICP License**: Internet Content Provider license is required for apps with user-generated content or that host content on servers in China
  - Register through the Ministry of Industry and Information Technology (MIIT)
  - Processing typically takes 2-3 weeks
  
- **Software Copyright Registration** (recommended)
  - Register with the Copyright Protection Center of China (CPCC)
  - Provides legal protection for your app in China

- **Business Entity Requirement**
  - You need either:
    - A Chinese business entity (WFOE, Joint Venture, etc.)
    - Partnership with a Chinese publisher who has the proper licenses

### 2. Data Compliance

- **Data Storage**: Personal user data of Chinese citizens must be stored on servers within mainland China
- **Network Security Assessment**: Required for apps that collect a significant amount of user data
- **Privacy Policy**: Must comply with China's Personal Information Protection Law (PIPL)

### 3. Content Compliance

- Remove any politically sensitive content
- Ensure all maps show China's territories according to Chinese government standards
- Remove references to Taiwan as a country or any other geopolitically sensitive content
- No gambling features (even simulated)
- Appropriate age ratings and content restrictions

## Technical Preparation

1. **Localization**:
   - Translate app content to Simplified Chinese (zh-Hans)
   - Adapt UI layout for Chinese text (which may require more or less space)
   - Update screenshots for the Chinese App Store listing

2. **Optimize for Chinese Networks**:
   - Use CDNs with presence in mainland China
   - Implement efficient data loading with poor connection handling
   - Consider integration with Chinese cloud services

3. **Integration with Chinese Services**:
   - Add popular Chinese payment services (Alipay, WeChat Pay)
   - Implement login options with WeChat, QQ, or Weibo
   - Replace Google services with Chinese alternatives (Baidu Maps, etc.)

## App Store Submission Process

1. **Apple Developer Account Setup**:
   - Standard Apple Developer Program membership ($99/year)
   - Ensure your legal entity information is correctly set up

2. **App Store Connect Configuration**:
   - Create a new app or add China to territories for your existing app
   - Set up a China-specific pricing tier
   - Prepare Chinese app description, keywords, and screenshots
   - Provide China-specific privacy policy URL

3. **App Review Information**:
   - Prepare demo account credentials
   - Include special instructions for reviewers
   - Provide contact information available during China business hours

4. **Required Documentation to Submit**:
   - ICP license or filing number (if applicable)
   - Publisher license (if your app publishes content)
   - Software copyright certificate (recommended)
   - Any additional permits required for your specific app category

5. **App Review Process**:
   - Expect longer review times (1-2 weeks is common)
   - Be prepared for additional information requests
   - Have a Chinese-speaking team member available to communicate with reviewers

## Post-Release Considerations

1. **Customer Support**:
   - Provide support in Simplified Chinese
   - Consider WeChat as a support channel
   - Set up support hours that accommodate China time zone

2. **App Monitoring**:
   - Regularly check for policy changes from both Apple and Chinese authorities
   - Monitor app performance on Chinese networks
   - Track Chinese user feedback and metrics separately

3. **Updates**:
   - Each update will need to go through the same review process
   - Plan for potential delays in update approvals

## Common Pitfalls to Avoid

- Submitting apps with VPN functionality (prohibited)
- Including links to blocked services (Google, Facebook, etc.)
- Using map data that doesn't conform to Chinese territorial standards
- Insufficient Chinese language support
- Lack of proper documentation for regulatory compliance

## Helpful Resources

- [Apple's Guide for Submitting Apps to China](https://developer.apple.com/cn/)
- [Ministry of Industry and Information Technology](http://www.miit.gov.cn/)
- [Copyright Protection Center of China](http://www.ccopyright.com.cn/)
