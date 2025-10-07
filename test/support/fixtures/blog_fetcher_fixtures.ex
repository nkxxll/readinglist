defmodule Readinglist.BlogFetcherFixtures do
  def example_blog_list_for_parsing(number) do
    case number do
      0 ->
        ~S(
      <div class="available-content">
        <div>
          <ul>
            <li><a href="http://example.com/1">Title 1</a> Description 1</li>
            <li><a href="http://example.com/2">Title 2</a> Description 2</li>
          </ul>
        </div>
      </div>
    )

      _ ->
        ~S(
        <div class="label">
  Share
</div>
<div class="visibility-check"></div>
<div>
  <div class="available-content">
    <div dir="auto" class="body markup">
      <p>It’s Saturday evening, it’s still bright and sunny and warm outside. I mowed the lawn, wrote some code, grilled some burgers, reverted some other code, ate too much ice cream, had a beer, and I don’t think I’ve ever written this newsletter on a Saturday evening.</p>
      <p><span>I’ll be in San Francisco in the first two weeks of August. One week of work, one week off. I’m also going to give a talk at the</span> <a href="https://lu.ma/ai-dev-tools-night-sf-0805" rel="">AI Dev Tools Night</a> <span>and if you’re around: say hi!</span></p>
      <div class="captioned-image-container">
        <figure>
          <a target="_blank" href="" data-component-name="Image2ToDOM" rel="" class="image-link image2">
          <div class="image2-inset">
            <picture><source type="image/webp" srcset="https://substackcdn.com/image/fetch/$s_!ZFxE!,w_424,c_limit,f_webp,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F52f72527-3c00-41ab-a6e9-d99eaabcef70.tif 424w, https://substackcdn.com/image/fetch/$s_!ZFxE!,w_848,c_limit,f_webp,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F52f72527-3c00-41ab-a6e9-d99eaabcef70.tif 848w, https://substackcdn.com/image/fetch/$s_!ZFxE!,w_1272,c_limit,f_webp,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F52f72527-3c00-41ab-a6e9-d99eaabcef70.tif 1272w, https://substackcdn.com/image/fetch/$s_!ZFxE!,w_1456,c_limit,f_webp,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F52f72527-3c00-41ab-a6e9-d99eaabcef70.tif 1456w" sizes="100vw"><img src="https://substackcdn.com/image/fetch/$s_!ZFxE!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F52f72527-3c00-41ab-a6e9-d99eaabcef70.tif" width="968" height="40" data-attrs="" alt="https%3A%2F%2Fsubstack-post-media" srcset="" sizes="100vw" fetchpriority="high" class="sizing-normal"></picture>
          </div></a>
        </figure>
      </div>
      <ul>
        <li>
          <p><span>My favorite this week: matklad’s</span> <a href="https://matklad.github.io/2025/07/07/inverse-triangle-inequality.html" rel="">Inverse Triangle Inequality</a><span>. Small commits, small refactors, small releases. Yes, yes, yes.</span></p>
        </li>
      </ul>
    </div>
  </div>
</div>
      )
    end
  end
end
