export default function getCsrfToken() {
  let metaTag = document.querySelector('meta[name="csrf-token"]')
  if (metaTag) {
    return metaTag.content;
  } else {
    return null;
  }
}
