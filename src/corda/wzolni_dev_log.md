Having multiple Java versions installed on a Mac is a common practice for developers. Here's how you can install and manage multiple Java versions on your Mac:

1. Use a version manager:
   The easiest way to manage multiple Java versions is to use a version manager. Two popular options are:

   a) SDKMAN!:
   - Install SDKMAN! by running:
     `curl -s "https://get.sdkman.io" | bash`
   - Open a new terminal or run `source "$HOME/.sdkman/bin/sdkman-init.sh"`
   - List available Java versions:
     `sdk list java`
   - Install Java 17:
     `sdk install java 17.0.11-zulu`

   b) Homebrew with jenv:
   - Install Homebrew if you haven't:
     `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
   - Install jenv:
     `brew install jenv`
   - Add jenv to your shell:
     `echo 'eval "$(jenv init -)"' >> ~/.zshrc` (or ~/.bash_profile for Bash)

2. Manual installation:
   - Download the Java 17 JDK for ARM64 Macs from a provider like Azul, AdoptOpenJDK, or Oracle.
   - Install it alongside your existing Java 21 installation.

3. Set up your environment:
   - If using SDKMAN!, switch versions with:
     `sdk use java 17.0.7-zulu`

   - If using jenv:
     - Add your Java versions:
       `jenv add /Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home`
     - Set a global version:
       `jenv global 17`
     - Or set a local version for a project:
       `jenv local 17`

4. Verify installation:
   - Check the current Java version:
     `java -version`

5. For your Gradle project:
   - You might need to specify the Java home in your `gradle.properties` file:
     `org.gradle.java.home=/path/to/your/java17/home`

Remember to switch between versions as needed for different projects. The version manager approach (SDKMAN! or jenv) is generally more convenient for managing multiple Java versions.

Would you like me to explain any part of this process in more detail?