class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag => "v18.06.0-ce",
      :revision => "0ffa8257ec673ed6849b73b03fb01b0cac90fdb3"

  bottle :unneeded

  conflicts_with "docker",
    :because => "docker already includes these completion scripts"

  def install
    bash_completion.install "components/cli/contrib/completion/bash/docker"
    fish_completion.install "components/cli/contrib/completion/fish/docker.fish"
    zsh_completion.install "components/cli/contrib/completion/zsh/_docker"
  end

  test do
    assert_match "-F _docker",
      shell_output("bash -c 'source #{bash_completion}/docker && complete -p docker'")
  end
end
