class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://ytdl-org.github.io/youtube-dl/"
  url "https://github.com/ytdl-org/youtube-dl/releases/download/2019.03.18/youtube-dl-2019.03.18.tar.gz"
  sha256 "074688b416e97aff5ae9ce3764e313b9d6433bb34a16b206775fbc37e4c16164"

  head do
    url "https://github.com/ytdl-org/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  bottle :unneeded

  def install
    system "make", "PREFIX=#{prefix}" if build.head?
    bin.install "youtube-dl"
    man1.install "youtube-dl.1"
    bash_completion.install "youtube-dl.bash-completion"
    zsh_completion.install "youtube-dl.zsh" => "_youtube-dl"
    fish_completion.install "youtube-dl.fish"
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pqRo9ATosas&list=PLHFlHpPjgk7048pY1TSGu1OZVOkMDdgoy"
  end
end
