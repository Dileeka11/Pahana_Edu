<%-- Staff Navbar fragment: do NOT add a page directive here to avoid conflicts when included --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${ctx}/assets/css/navbar.css?v=1" />
<script src="${ctx}/assets/js/navbar.js?v=1" defer></script>

<nav class="staff-navbar" role="navigation" aria-label="Staff navigation">
  <div class="staff-brand">
    <a href="${ctx}/staff/staffpanel.jsp" class="staff-brand-link" style="text-decoration:none; color:inherit;" aria-label="Pahana Edu Staff Home">
      <img src="${ctx}/assets/img/logo.png" alt="Pahana Edu" class="staff-logo" />
      <span>Pahana Edu : Staff</span>
    </a>
  </div>

  <div class="staff-links">
    <a href="${ctx}/staff/staffpanel.jsp"
       class="<c:if test='${activePage == "dashboard"}'>active-link</c:if>">Dashboard</a>

    <a href="${ctx}/staff/checkout.jsp"
       class="<c:if test='${activePage == "checkout"}'>active-link</c:if>">Checkout</a>

    <!-- Example extra links: uncomment and set activePage accordingly
    <a href="${ctx}/staff/books.jsp"
       class="<c:if test='${activePage == "books"}'>active-link</c:if>">Books</a>
    <a href="${ctx}/staff/billing.jsp"
       class="<c:if test='${activePage == "billing"}'>active-link</c:if>">Billing</a>
    -->

    <span class="staff-user">
      <c:choose>
        <c:when test="${not empty sessionScope.staffName}">
          Signed in as: ${sessionScope.staffName}
        </c:when>
        <c:when test="${not empty sessionScope.userName}">
          Signed in as: ${sessionScope.userName}
        </c:when>
        <c:when test="${not empty sessionScope.username}">
          Signed in as: ${sessionScope.username}
        </c:when>
        <c:otherwise>
          Signed in
        </c:otherwise>
      </c:choose>
    </span>

    <a href="${ctx}/logout.jsp" style="margin-left:auto;">Logout</a>
  </div>
</nav>